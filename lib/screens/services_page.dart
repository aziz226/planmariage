import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/data.dart';
import '../core/models.dart';
import '../core/routes.dart';
import '../providers/category_provider.dart';
import '../providers/providers_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text.dart';
import '../widgets/header.dart';
import '../widgets/provider_card.dart';
import 'footer_view.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  String? selectedValue, selectedVille;
  final _searchCtrl = TextEditingController();
  int selectedIndex = 1;
  static const List<String> _mobileRoutes = [
    homeRoute,
    serviceRoute,
    prestatairesRoute,
    contactRoute,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = context.read<ProvidersProvider>();
      prov.loadProviders();
      prov.loadFeaturedProviders();
      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final prov = context.read<ProvidersProvider>();
    prov.setCategory(selectedValue);
    prov.setVille(selectedVille);
    if (_searchCtrl.text.isNotEmpty) {
      prov.setSearch(_searchCtrl.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final prov = context.watch<ProvidersProvider>();
    final catProv = context.watch<CategoryProvider>();
    final dbCategories = catProv.categories;

    return ResponsiveBuilder(builder: (context, screenSize) {
      final isMobile = screenSize.isMobile;
      final isTablet = screenSize.isTablet;
      final isDesktop = screenSize.isDesktop;

      return Scaffold(
        //drawer: isMobile ? const AppDrawer(index: 1,) : null,
        body: Column(
          children: [
            const SizedBox(height: 10),
            const Header(index: 1),
            const Divider(thickness: 0.5, color: Colors.black),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Découvrez nos\n',
                          style: GoogleFonts.montserrat(
                            fontSize: isMobile ? 18 : 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'prestataires de qualité',
                          style: GoogleFonts.montserrat(
                            fontSize: isMobile ? 18 : 38,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: isDesktop ? width * 0.6 : width,
                      child: const AppText(
                        text: "Plus de 1000 professionnels sélectionnés pour faire de votre mariage un moment inoubliable",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        alignement: TextAlign.center,
                        color: Colors.black54,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFilterCard(),
                    const SizedBox(height: 20),
                    _buildPromotedBanner(prov, isMobile),
                    if (catProv.loading)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      )
                    else if (dbCategories.isNotEmpty)
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: dbCategories.map((cat) => _buildCategoryCard(context, cat, width, isMobile, isTablet, isDesktop)).toList(),
                      ),

                    //_buildResultsList(width, isMobile, prov),
                    SizedBox(height: isMobile? 20: 40,),
                    if(!isMobile)
                      const FooterView(),
                  ],
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

  Widget _buildFilterCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: _searchCtrl,
                onFieldSubmitted: (_) => _applyFilters(),
                decoration: InputDecoration(
                  hint: AppText(text: 'Rechercher ...', color: Colors.black.withOpacity(0.7)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: primaryColor, width: 0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  prefixIcon: const Icon(IconlyLight.search),
                ),
              ),
            ),
            SizedBox(
              width: 250,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Toutes les catégories',
                  hintStyle: GoogleFonts.montserrat(color: Colors.black.withOpacity(0.7)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: primaryColor, width: 0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                value: selectedValue,
                items: context.watch<CategoryProvider>().categories.map((c) => DropdownMenuItem(
                  value: c.name,
                  child: AppText(text: c.name),
                )).toList(),
                onChanged: (value) {
                  setState(() { selectedValue = value; });
                },
              ),
            ),
            SizedBox(
              width: 250,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Toutes les villes',
                  hintStyle: GoogleFonts.montserrat(color: Colors.black.withOpacity(0.7)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: primaryColor, width: 0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                value: selectedVille,
                items: villes.map((v) => DropdownMenuItem(
                  value: v,
                  child: AppText(text: v),
                )).toList(),
                onChanged: (value) {
                  setState(() { selectedVille = value; });
                },
              ),
            ),
            AppButton(text: 'Filtrer', onPressed: _applyFilters),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotedBanner(ProvidersProvider prov, bool isMobile) {
    final featured = prov.featuredProviders;
    if (featured.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFFD700).withValues(alpha: 0.1),
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
            SizedBox(
              height: isMobile ? 280 : 310,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featured.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) => SizedBox(
                  width: isMobile ? 220 : 320,
                  child: ProviderCard(provider: featured[i], isFeatured: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(double width, bool isMobile, ProvidersProvider prov) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: prov.loading
                  ? const CircularProgressIndicator()
                  : AppText(
                      text: '${prov.providers.length} prestataires trouvés',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (prov.providers.isEmpty && !prov.loading)
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text('Aucun prestataire trouvé', style: GoogleFonts.montserrat(color: Colors.grey)),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: prov.providers.map((p) => SizedBox(
                width: isMobile ? width * 0.42 : 320,
                child: ProviderCard(provider: p),
              )).toList(),
            ),
          ),
        const SizedBox(height: 30),

        if(!isMobile)
          const FooterView(),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel cat, double width, bool isMobile, bool isTablet, bool isDesktop) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, prestatairesRoute, arguments: {'category': cat.name});
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: SizedBox(
          width: isMobile ? width * 0.4 : isTablet ? 300 : width * 0.2,
          height: isDesktop ? 250 : isTablet ? 250 : 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              CircleAvatar(
                radius: isMobile ? 25 : 35,
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Icon(cat.iconData, size: isMobile ? 25 : 35, color: primaryColor),
              ),
              AppText(text: cat.name, fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.w600),
              if (cat.providerCount > 0)
                AppText(
                  text: "${cat.providerCount}+ prestataires",
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

}
