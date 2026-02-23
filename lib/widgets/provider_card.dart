import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/models.dart';
import '../core/routes.dart';
import '../providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/providers_provider.dart';
import 'rating_stars.dart';

class ProviderCard extends StatelessWidget {
  final ProviderModel provider;
  final bool? isFeatured;
  const ProviderCard({super.key, required this.provider, this.isFeatured});

  @override
  Widget build(BuildContext context) {
    final hasImage = provider.imageUrls.isNotEmpty;
    final featured = isFeatured ?? context.watch<ProvidersProvider>().isFeatured(provider.id);
    final auth = context.watch<AuthProvider>();
    final favProv = context.watch<FavoritesProvider>();
    final isFav = auth.isAuthenticated && favProv.isFavorite(provider.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: featured ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: featured
            ? const BorderSide(color: Color(0xFFFFD700), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          '$providerDetailRoute/${provider.id}',
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + badges
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: hasImage
                      ? CachedNetworkImage(
                          imageUrl: provider.imageUrls.first,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: Colors.grey[200],
                            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                if (featured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'En vedette',
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Bouton favori
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
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
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          isFav ? IconlyBold.heart : IconlyLight.heart,
                          size: 20,
                          color: isFav ? Colors.red : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Catégorie
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      provider.serviceCategory,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Nom
                  Text(
                    provider.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Ville
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        provider.ville,
                        style: GoogleFonts.montserrat(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating + prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RatingStars(rating: provider.rating, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '(${provider.reviewCount})',
                            style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Text(
                          'À partir de ${_formatPrice(provider.priceFrom)}',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.image_outlined, size: 48, color: Colors.grey)),
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
