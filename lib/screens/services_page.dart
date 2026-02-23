import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/data.dart';
import '../core/routes.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProvidersProvider>().loadProviders();
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

    return ResponsiveBuilder(builder: (context, screenSize) {
      final isMobile = screenSize.isMobile;
      final isDesktop = screenSize.isDesktop;

      return Scaffold(
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
                    _buildResultsList(width, isMobile, prov),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                items: services.map((s) => DropdownMenuItem(
                  value: s.title,
                  child: AppText(text: s.title),
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
        const FooterView(),
      ],
    );
  }
}
