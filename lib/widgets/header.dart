import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/routes.dart';
import '../core/variable_name.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'app_text.dart';

class Header extends StatelessWidget {
  final int index;
  const Header({super.key, required this.index});

  static const List<String> _menuItems = [
    'Accueil',
    'Services',
    'Prestataires',
    'Contact',
  ];

  static const List<String> _routes = [
    homeRoute,
    serviceRoute,
    prestatairesRoute,
    contactRoute,
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final isLoggedIn = auth.isAuthenticated;

    return ResponsiveBuilder(builder: (context, screenSize) {
      final isMobile = screenSize.isMobile;
      final isDesktop = screenSize.isDesktop;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            if (isDesktop)
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, homeRoute),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.heart_fill, color: primaryColor, size: 40),
                    const SizedBox(width: 4),
                    AppText(text: appName, fontWeight: FontWeight.bold, fontSize: 32),
                  ],
                ),
              ),

            // Menu navigation (tablet + desktop)
            if (!isMobile)
              Row(
                children: List.generate(_menuItems.length, (i) => TextButton(
                  onPressed: () => Navigator.pushNamed(context, _routes[i]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AppText(
                      text: _menuItems[i],
                      fontWeight: index == i ? FontWeight.bold : FontWeight.w500,
                      fontSize: 18,
                      color: index == i ? primaryColor : Colors.black54,
                    ),
                  ),
                )),
              ),

            // Actions (panier + auth)
            Row(
              children: [
                // Bouton favoris (si connecté)
                if (isLoggedIn)
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, favoritesRoute),
                    icon: const Icon(IconlyLight.heart, color: Colors.black54),
                    tooltip: 'Mes favoris',
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      hoverColor: primaryColor.withValues(alpha: 0.1),
                    ),
                  ),

                // Bouton panier avec badge
                Stack(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pushNamed(context, cartRoute),
                      icon: const Icon(IconlyLight.buy, color: Colors.black54),
                      tooltip: 'Panier',
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        hoverColor: primaryColor.withValues(alpha: 0.1),
                      ),
                    ),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 8),

                // Bouton authentification
                if (isLoggedIn)
                  PopupMenuButton<String>(
                    tooltip: 'Mon compte',
                    offset: const Offset(0, 50),
                    onSelected: (value) {
                      switch (value) {
                        case 'profile':
                          Navigator.pushNamed(context, profileRoute);
                          break;
                        case 'bookings':
                          Navigator.pushNamed(context, bookingsRoute);
                          break;
                        case 'favorites':
                          Navigator.pushNamed(context, favoritesRoute);
                          break;
                        case 'logout':
                          auth.logout();
                          Navigator.pushNamedAndRemoveUntil(context, homeRoute, (_) => false);
                          break;
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        enabled: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.user?.displayName ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Text(
                              auth.user?.email ?? '',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(IconlyLight.profile, size: 20),
                            SizedBox(width: 8),
                            Text('Mon profil'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'bookings',
                        child: Row(
                          children: [
                            Icon(IconlyLight.document, size: 20),
                            SizedBox(width: 8),
                            Text('Mes réservations'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'favorites',
                        child: Row(
                          children: [
                            Icon(IconlyLight.heart, size: 20),
                            SizedBox(width: 8),
                            Text('Mes favoris'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(IconlyLight.logout, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Déconnexion', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: primaryColor.withValues(alpha: 0.15),
                            child: Text(
                              (auth.user?.displayName ?? 'U')[0].toUpperCase(),
                              style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          if (!isMobile) ...[
                            const SizedBox(width: 8),
                            AppText(
                              text: auth.user?.displayName ?? 'Mon compte',
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ],
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down, color: primaryColor),
                        ],
                      ),
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, loginRoute),
                    icon: const Icon(IconlyLight.login, size: 18),
                    label: Text(isMobile ? 'Connexion' : 'Se connecter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
