import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/routes.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/pack_provider.dart';
import '../providers/providers_provider.dart';
import '../providers/review_provider.dart';
import '../widgets/header.dart';
import '../widgets/rating_stars.dart';
import '../widgets/review_card.dart';

class ProviderDetailPage extends StatefulWidget {
  final String providerId;
  const ProviderDetailPage({super.key, required this.providerId});

  @override
  State<ProviderDetailPage> createState() => _ProviderDetailPageState();
}

class _ProviderDetailPageState extends State<ProviderDetailPage> {
  int _currentImage = 0;
  int _newRating = 0;
  final _commentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProvidersProvider>().loadProviderById(widget.providerId);
      context.read<ReviewProvider>().loadReviews(widget.providerId);
      context.read<PackProvider>().loadProviderPacks(widget.providerId);
    });
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provProv = context.watch<ProvidersProvider>();
    final reviewProv = context.watch<ReviewProvider>();
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final provider = provProv.selectedProvider;
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 800;

    if (provProv.loading || provider == null) {
      return Scaffold(
        body: Column(
          children: [
            const Header(index: 2),
            const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      );
    }

    final inCart = cart.containsProvider(provider.id);

    return Scaffold(
      body: Column(
        children: [
          const Header(index: 2),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _buildLeftColumn(provider)),
                            const SizedBox(width: 32),
                            Expanded(flex: 2, child: _buildRightColumn(provider, inCart, auth, reviewProv)),
                          ],
                        )
                      : Column(
                          children: [
                            _buildLeftColumn(provider),
                            const SizedBox(height: 24),
                            _buildRightColumn(provider, inCart, auth, reviewProv),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftColumn(provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Galerie images
        if (provider.imageUrls.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: CachedNetworkImage(
                imageUrl: provider.imageUrls[_currentImage],
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey[200]),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_outlined, size: 64),
                ),
              ),
            ),
          ),
          if (provider.imageUrls.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.imageUrls.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => setState(() => _currentImage = i),
                    child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: i == _currentImage ? primaryColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: provider.imageUrls[i],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ] else
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Icon(Icons.image_outlined, size: 64, color: Colors.grey)),
          ),
        const SizedBox(height: 24),
        // Description
        Text('Description', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(provider.description, style: GoogleFonts.montserrat(fontSize: 15, color: Colors.grey[700], height: 1.6)),
        const SizedBox(height: 32),
        // Packs section
        _buildPacksSection(),
      ],
    );
  }

  Widget _buildPacksSection() {
    final packProv = context.watch<PackProvider>();

    if (packProv.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (packProv.packs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nos Packs', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...packProv.packs.map((pack) => _buildPackCard(pack)),
      ],
    );
  }

  Widget _buildPackCard(pack) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    pack.name,
                    style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: pack.level == 'Recommandé' ? Colors.green : primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pack.level,
                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              pack.formattedPrice,
              style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            if (pack.description != null && pack.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                pack.description!,
                style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
            if (pack.services.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...pack.services.map<Widget>((service) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(service, style: GoogleFonts.montserrat(fontSize: 14)),
                    ),
                  ],
                ),
              )),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartProvider>().addPack(pack);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${pack.name} ajouté au panier !'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Choisir ce pack', style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightColumn(provider, bool inCart, AuthProvider auth, ReviewProvider reviewProv) {
    final favProv = context.watch<FavoritesProvider>();
    final isFav = auth.isAuthenticated && favProv.isFavorite(provider.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Infos principales
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        provider.name,
                        style: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (provider.isVerified)
                      const Tooltip(
                        message: 'Prestataire vérifié',
                        child: Icon(Icons.verified, color: Colors.blue),
                      ),
                  ],
                ),
                // Badge "En vedette" si abonné
                if (context.watch<ProvidersProvider>().isFeatured(provider.id)) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          'Prestataire en vedette',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    provider.serviceCategory,
                    style: GoogleFonts.montserrat(color: primaryColor, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 16),
                _infoRow(Icons.location_on_outlined, provider.ville + (provider.address != null ? ', ${provider.address}' : '')),
                if (provider.phone != null) _infoRow(Icons.phone_outlined, provider.phone!),
                if (provider.email != null) _infoRow(Icons.email_outlined, provider.email!),
                const Divider(height: 24),
                Row(
                  children: [
                    RatingStars(rating: provider.rating, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      '${provider.rating.toStringAsFixed(1)} (${provider.reviewCount} avis)',
                      style: GoogleFonts.montserrat(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Text(
                  'À partir de ${_formatPrice(provider.priceFrom)}',
                  style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: inCart
                              ? null
                              : () {
                                  context.read<CartProvider>().addProvider(provider);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Ajouté au panier !'), backgroundColor: Colors.green),
                                  );
                                },
                          icon: Icon(inCart ? Icons.check : Icons.add_shopping_cart),
                          label: Text(
                            inCart ? 'Déjà dans le panier' : 'Ajouter au panier',
                            style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      width: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          if (!auth.isAuthenticated) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Connectez-vous pour ajouter aux favoris'),
                                action: SnackBarAction(
                                  label: 'Connexion',
                                  onPressed: () => Navigator.pushNamed(context, loginRoute),
                                ),
                              ),
                            );
                            return;
                          }
                          favProv.toggleFavorite(auth.uid!, provider.id);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: isFav ? Colors.red : Colors.grey[400]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.zero,
                        ),
                        child: Icon(
                          isFav ? IconlyBold.heart : IconlyLight.heart,
                          color: isFav ? Colors.red : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Section avis
        Text('Avis', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // Formulaire d'avis si connecté
        if (auth.isAuthenticated) ...[
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Donner votre avis', style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  RatingStars(
                    rating: _newRating.toDouble(),
                    size: 32,
                    onRatingChanged: (v) => setState(() => _newRating = v),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Votre commentaire (optionnel)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _newRating == 0
                          ? null
                          : () async {
                              final ok = await reviewProv.addReview(
                                userId: auth.uid!,
                                providerId: provider.id,
                                rating: _newRating,
                                comment: _commentCtrl.text.trim().isEmpty ? null : _commentCtrl.text.trim(),
                              );
                              if (!mounted) return;
                              if (ok) {
                                setState(() => _newRating = 0);
                                _commentCtrl.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Avis ajouté !'), backgroundColor: Colors.green),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                      child: const Text('Publier'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ] else ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Connectez-vous pour laisser un avis', style: GoogleFonts.montserrat(color: Colors.grey[600]))),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, loginRoute),
                    child: const Text('Se connecter'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Liste des avis
        if (reviewProv.loading)
          const Center(child: CircularProgressIndicator())
        else if (reviewProv.reviews.isEmpty)
          Text('Aucun avis pour le moment', style: GoogleFonts.montserrat(color: Colors.grey))
        else
          ...reviewProv.reviews.map((r) => ReviewCard(review: r)),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey[700]))),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(str[i]);
    }
    return '$buffer FCFA';
  }
}
