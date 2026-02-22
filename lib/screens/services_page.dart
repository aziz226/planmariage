import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:plan_mariage/screens/footer_view.dart';
import 'package:plan_mariage/widgets/app_button.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/data.dart';
import '../widgets/app_text.dart';
import '../widgets/header.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  String? selectedValue, selectedVille;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
                    _buildResultsList(width, isMobile),
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
            AppButton(text: 'Filtrer', onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(double width, bool isMobile) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AppText(text: '${services.length} prestataires trouvés', fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: services.map((service) => _buildProviderCard(service, width, isMobile)).toList(),
        ),
        const SizedBox(height: 30),
        const FooterView(),
      ],
    );
  }

  Widget _buildProviderCard(service, double width, bool isMobile) {
    return InkWell(
      onTap: () {},
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: SizedBox(
          width: isMobile ? width * 0.4 : 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/hero-wedding.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: AppText(text: service.title, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                    const AppText(text: "Divers Shoot", fontSize: 18, fontWeight: FontWeight.bold),
                    const Row(
                      children: [
                        Icon(IconlyLight.location, color: Colors.black54, size: 16),
                        SizedBox(width: 5),
                        AppText(text: "Ouagadougou, Zone 1", color: Colors.black54),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AppText(text: service.description, color: Colors.black54, overflow: TextOverflow.clip),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        AppText(
                          text: 'A partir de 325 000fcfa',
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
