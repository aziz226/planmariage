import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/data.dart';
import '../core/routes.dart';
import '../providers/cart_provider.dart';
import '../providers/providers_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text.dart';
import '../widgets/hover_button.dart';
import '../widgets/provider_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProvidersProvider>().loadFeaturedProviders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return ResponsiveBuilder(builder: (context, screenSize) {
      final isMobile = screenSize.isMobile;
      final isTablet = screenSize.isTablet;
      final isDesktop = screenSize.isDesktop;

      return Column(
        children: [
          _buildHeroSection(context, width, height, isMobile, isDesktop),
          SizedBox(height: isDesktop ? 60 : 20),
          _buildFeaturedSection(context, width, isMobile, isTablet, isDesktop),
          _buildServicesSection(context, width, isMobile, isTablet, isDesktop),
          SizedBox(height: isDesktop ? 60 : 20),
          _buildPacksSection(context, width, isMobile, isTablet, isDesktop),
        ],
      );
    });
  }

  Widget _buildFeaturedSection(BuildContext context, double width, bool isMobile, bool isTablet, bool isDesktop) {
    final provProv = context.watch<ProvidersProvider>();
    final featured = provProv.featuredProviders;

    if (provProv.featuredLoading || featured.isEmpty) {
      return const SizedBox.shrink();
    }

    final cardWidth = isMobile ? width * 0.9 : isTablet ? 350.0 : width * 0.28;

    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: 'Prestataires ',
              style: GoogleFonts.montserrat(
                fontSize: isMobile ? 22 : 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'en vedette',
              style: GoogleFonts.montserrat(
                fontSize: isMobile ? 22 : 32,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: isDesktop ? width * 0.6 : width,
          child: const AppText(
            text: "Des prestataires de confiance sélectionnés pour la qualité de leurs services.",
            fontSize: 18,
            fontWeight: FontWeight.w500,
            alignement: TextAlign.center,
            color: Colors.black54,
            overflow: TextOverflow.clip,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: featured.map((provider) => SizedBox(
              width: cardWidth,
              child: ProviderCard(provider: provider),
            )).toList(),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, double width, double height, bool isMobile, bool isDesktop) {
    final searchCtrl = TextEditingController();

    return Stack(
      children: [
        Container(
          height: height * 0.8,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/hero-wedding.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
        ),
        Container(
          height: height * 0.8,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.6),
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.08),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: isDesktop ? width * 0.5 : width,
            height: height * 0.8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20.0),
              child: Column(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Votre mariage de\n',
                          style: GoogleFonts.montserrat(
                            fontSize: isMobile ? 32 : 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'rêve commence ici.',
                          style: GoogleFonts.montserrat(
                            fontSize: isMobile ? 32 : 48,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  AppText(
                    text: "Découvrez tous les services pour organiser le mariage parfait. Des prestataires de qualité, des packs adaptés à votre budget.",
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.w500,
                    alignement: TextAlign.justify,
                    color: Colors.black54,
                    overflow: TextOverflow.clip,
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: searchCtrl,
                          onFieldSubmitted: (query) {
                            if (query.isNotEmpty) {
                              Navigator.pushNamed(context, prestatairesRoute, arguments: {'search': query});
                            }
                          },
                          decoration: InputDecoration(
                            hint: AppText(
                              text: 'Rechercher un service, un lieu, un prestataire...',
                              color: Colors.black.withOpacity(0.7),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.white, width: 0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.white, width: 0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            prefixIcon: const Icon(IconlyLight.search),
                          ),
                        ),
                      ),
                      AppButton(
                        text: 'Rechercher',
                        onPressed: () {
                          final query = searchCtrl.text.trim();
                          if (query.isNotEmpty) {
                            Navigator.pushNamed(context, prestatairesRoute, arguments: {'search': query});
                          }
                        },
                      ),
                    ],
                  ),
                  Wrap(
                    runSpacing: 20,
                    spacing: 20,
                    children: [
                      AppButton(
                        text: 'Découvrir nos packs',
                        onPressed: () => Navigator.pushNamed(context, serviceRoute),
                      ),
                      AppButton(
                        text: 'Voir tous les services',
                        onPressed: () => Navigator.pushNamed(context, serviceRoute),
                        btnColor: Colors.white,
                        textColor: primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection(BuildContext context, double width, bool isMobile, bool isTablet, bool isDesktop) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: 'Tous nos services de mariage\n',
              style: GoogleFonts.montserrat(
                fontSize: isMobile ? 22 : 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'en un seul endroit',
              style: GoogleFonts.montserrat(
                fontSize: isMobile ? 22 : 32,
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
            text: "Une sélection rigoureuse de prestataires professionnels pour chaque aspect de votre mariage.",
            fontSize: 18,
            fontWeight: FontWeight.w500,
            alignement: TextAlign.center,
            color: Colors.black54,
            overflow: TextOverflow.clip,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: services.map((service) => _buildServiceCard(context, service, width, isMobile, isTablet, isDesktop)).toList(),
        ),
        const SizedBox(height: 30),
        AppButton(
          text: 'Voir les services',
          onPressed: () => Navigator.pushNamed(context, serviceRoute),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, service, double width, bool isMobile, bool isTablet, bool isDesktop) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, prestatairesRoute, arguments: {'category': service.title});
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: SizedBox(
          width: isMobile ? width * 0.4 : isTablet ? 300 : width * 0.2,
          height: isDesktop ? 300 : isTablet ? 300 : 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 15,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: CircleAvatar(
                  radius: isMobile ? 25 : 35,
                  backgroundColor: primaryColor.withOpacity(0.1),
                  child: Icon(service.icon, size: isMobile ? 25 : 35, color: primaryColor),
                ),
              ),
              AppText(text: service.title, fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.w600),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AppText(
                  text: service.description,
                  color: Colors.grey,
                  alignement: TextAlign.center,
                  overflow: TextOverflow.clip,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                child: AppText(
                  text: "${service.count}+ ${service.providerLabel}",
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPacksSection(BuildContext context, double width, bool isMobile, bool isTablet, bool isDesktop) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: 'Nos packs tout compris\n',
              style: GoogleFonts.montserrat(
                fontSize: isMobile ? 22 : 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'adaptés à votre budget',
              style: GoogleFonts.montserrat(
                fontSize: isMobile ? 22 : 32,
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
            text: "Simplifiez-vous la vie avec nos formules clés en main, conçues par nos experts",
            fontSize: 18,
            fontWeight: FontWeight.w500,
            alignement: TextAlign.center,
            color: Colors.black54,
            overflow: TextOverflow.clip,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: packs.map((pack) => _buildPackCard(context, pack, width, isMobile, isTablet, isDesktop)).toList(),
          ),
        ),
        const SizedBox(height: 40),
        const AppText(
          text: "Besoin d'un pack ? Nos experts sont là pour vous accompagner.",
          fontSize: 18,
          color: Colors.black45,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 50,
          child: HoverButton(
            text: 'Demander un devis sur mesure',
            defaultColor: Colors.white,
            hoveringColor: primaryColor,
            onPressed: () => Navigator.pushNamed(context, contactRoute),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildPackCard(BuildContext context, pack, double width, bool isMobile, bool isTablet, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor, width: 1),
      ),
      width: isMobile ? width : isTablet ? 350 : width * 0.3,
      height: isDesktop ? 800 : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: AppText(text: pack.name, fontSize: isMobile ? 16 : 22, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: pack.level == "Recommandé" ? Colors.green : primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                    child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(IconlyLight.star, color: Colors.white, size: 16),
                        AppText(text: pack.level, fontWeight: FontWeight.bold, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(children: [
                TextSpan(
                  text: '${pack.formattedPrice} ',
                  style: GoogleFonts.montserrat(
                    fontSize: isMobile ? 22 : 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                TextSpan(
                  text: 'à partir de',
                  style: GoogleFonts.montserrat(color: Colors.black54, fontSize: 18),
                ),
              ]),
            ),
            AppText(
              text: pack.description,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              alignement: TextAlign.start,
              color: Colors.black54,
              overflow: TextOverflow.clip,
            ),
            ...pack.services.map<Widget>((item) => Row(
              children: [
                const Icon(Icons.check, color: primaryColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: AppText(text: item, fontSize: 18, alignement: TextAlign.start, overflow: TextOverflow.clip),
                ),
              ],
            )),
            if (isDesktop) const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: HoverButton(
                text: 'Choisir ce pack',
                defaultColor: Colors.white,
                hoveringColor: primaryColor,
                onPressed: () {
                  context.read<CartProvider>().addPack(pack);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${pack.name} ajouté au panier !'), backgroundColor: Colors.green),
                  );
                  Navigator.pushNamed(context, cartRoute);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
