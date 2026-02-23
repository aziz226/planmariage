import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/routes.dart';
import '../providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/auth_guard.dart';
import '../widgets/header.dart';
import '../widgets/provider_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = context.read<AuthProvider>().uid;
      if (uid != null) {
        context.read<FavoritesProvider>().loadFavorites(uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: ResponsiveBuilder(builder: (context, screenSize) {
        final isMobile = screenSize.isMobile;
        final isTablet = screenSize.isTablet;
        final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);

        return Scaffold(
          body: Column(
            children: [
              const Header(index: -1),
              Expanded(
                child: _buildContent(crossAxisCount, isMobile),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildContent(int crossAxisCount, bool isMobile) {
    final favProv = context.watch<FavoritesProvider>();
    final padding = isMobile ? 16.0 : 24.0;

    if (favProv.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (favProv.favorites.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(IconlyLight.heart, size: isMobile ? 60 : 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'Aucun favori pour le moment',
                style: GoogleFonts.montserrat(fontSize: isMobile ? 18 : 20, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Ajoutez des prestataires à vos favoris pour les retrouver ici',
                style: GoogleFonts.montserrat(fontSize: isMobile ? 13 : 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, prestatairesRoute),
                icon: const Icon(IconlyLight.search),
                label: const Text('Découvrir les prestataires'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes favoris',
            style: GoogleFonts.montserrat(fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '${favProv.favorites.length} prestataire(s)',
            style: GoogleFonts.montserrat(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.78,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favProv.favorites.length,
              itemBuilder: (_, i) => ProviderCard(provider: favProv.favorites[i]),
            ),
          ),
        ],
      ),
    );
  }
}
