import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/data.dart';
import '../core/routes.dart';
import '../providers/category_provider.dart';
import '../providers/providers_provider.dart';
import '../widgets/header.dart';
import '../widgets/provider_card.dart';
import 'footer_view.dart';

class PrestatairesPage extends StatefulWidget {
  final String? initialCategory;
  final String? initialSearch;
  const PrestatairesPage({super.key, this.initialCategory, this.initialSearch});

  @override
  State<PrestatairesPage> createState() => _PrestatairesPageState();
}

class _PrestatairesPageState extends State<PrestatairesPage> {
  bool isMobile = false, isTablet = false, isDesktop = false;
  int selectedIndex = 2;
  static const List<String> _mobileRoutes = [
    homeRoute,
    serviceRoute,
    prestatairesRoute,
    contactRoute,
  ];

  String? _selectedCategory;
  String? _selectedVille;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _searchCtrl.text = widget.initialSearch ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = context.read<ProvidersProvider>();
      prov.loadFeaturedProviders();
      context.read<CategoryProvider>().loadCategories();
      if (widget.initialCategory != null) prov.setCategory(widget.initialCategory);
      if (widget.initialSearch != null && widget.initialSearch!.isNotEmpty) {
        prov.setSearch(widget.initialSearch);
      } else {
        prov.loadProviders();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProvidersProvider>();
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200 ? 3 : (width > 700 ? 2 : 1);

    return ResponsiveBuilder(builder: (context, screenType){
      isMobile = screenType.isMobile;
      isTablet = screenType.isTablet;
      isDesktop = screenType.isDesktop;
      return Scaffold(
        body: Column(
          children: [
            const Header(index: 2),
            // Barre de filtres
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Colors.grey[50],
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Recherche
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Rechercher...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: (v) => prov.setSearch(v),
                    ),
                  ),
                  // Catégorie
                  _buildDropdown(
                    value: _selectedCategory,
                    hint: 'Catégorie',
                    items: context.watch<CategoryProvider>().categoryNames,
                    onChanged: (v) {
                      setState(() => _selectedCategory = v);
                      prov.setCategory(v);
                    },
                  ),
                  // Ville
                  _buildDropdown(
                    value: _selectedVille,
                    hint: 'Ville',
                    items: villes,
                    onChanged: (v) {
                      setState(() => _selectedVille = v);
                      prov.setVille(v);
                    },
                  ),
                  // Tri
                  PopupMenuButton<String>(
                    tooltip: 'Trier par',
                    onSelected: (v) {
                      switch (v) {
                        case 'recent':
                          prov.setSortBy('created_at');
                          break;
                        case 'price_asc':
                          prov.setSortBy('price_from', ascending: true);
                          break;
                        case 'price_desc':
                          prov.setSortBy('price_from');
                          break;
                        case 'rating':
                          prov.setSortBy('rating');
                          break;
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'recent', child: Text('Plus récents')),
                      PopupMenuItem(value: 'rating', child: Text('Meilleures notes')),
                      PopupMenuItem(value: 'price_asc', child: Text('Prix croissant')),
                      PopupMenuItem(value: 'price_desc', child: Text('Prix décroissant')),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sort, size: 18),
                          const SizedBox(width: 4),
                          Text('Trier', style: GoogleFonts.montserrat(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  // Reset
                  if (_selectedCategory != null || _selectedVille != null || _searchCtrl.text.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = null;
                          _selectedVille = null;
                          _searchCtrl.clear();
                        });
                        prov.clearFilters();
                      },
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Réinitialiser'),
                    ),
                ],
              ),
            ),
            // Résultats
            Expanded(
              child: prov.loading
                  ? const Center(child: CircularProgressIndicator())
                  : prov.providers.isEmpty && prov.featuredProviders.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun prestataire trouvé',
                      style: GoogleFonts.montserrat(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
                  : Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section prestataires sponsorisés
                      if (prov.featuredProviders.isNotEmpty) ...[
                        _buildPromotedSection(prov),
                       const SizedBox(height: 24),
                      ],
                      Text(
                        '${prov.providers.length} prestataire(s) trouvé(s)',
                        style: GoogleFonts.montserrat(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        children: [
                          for(int i = 0; i < prov.providers.length; i++)
                            ProviderCard(provider: prov.providers[i])

                        ],
                      ),

                      SizedBox(height: isMobile? 20: 40,),
                      if(!isMobile)
                        const FooterView(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: isMobile
            ? BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            if (index == 0) {
              setState(() { selectedIndex = index; });
              Navigator.pushNamed(context, _mobileRoutes[index]);
            } else {
              Navigator.pushNamed(context, _mobileRoutes[index]);
            }
          },
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(IconlyLight.home), label: 'Accueil'),
            BottomNavigationBarItem(icon: Icon(IconlyLight.category), label: 'Services'),
            BottomNavigationBarItem(icon: Icon(IconlyLight.search), label: 'Prestataires'),
            BottomNavigationBarItem(icon: Icon(IconlyLight.chat), label: 'Contact'),
          ],
        )
            : null,
      );
    });
  }

  Widget _buildPromotedSection(ProvidersProvider prov) {
    final featured = prov.featuredProviders;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD700).withValues(alpha: 0.08),
            const Color(0xFFFFA000).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    const SizedBox(width: 4),
                    Text(
                      'Prestataires en vedette',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Sponsorisé',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: featured.take(3).map((p) =>
                ProviderCard(provider: p, isFeatured: true),
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      width: 180,
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint),
        isExpanded: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        items: [
          DropdownMenuItem<String>(value: null, child: Text('Tous')),
          ...items.map((v) => DropdownMenuItem(value: v, child: Text(v))),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
