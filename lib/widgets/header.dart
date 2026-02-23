import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/data.dart';
import '../core/routes.dart';
import '../core/variable_name.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'app_button.dart';
import 'app_text.dart';

class Header extends StatelessWidget {
  final int index;
  const Header({super.key, required this.index});

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

    return ResponsiveBuilder(builder: (context, screenSize) {
      final isMobile = screenSize.isMobile;
      final isDesktop = screenSize.isDesktop;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, homeRoute),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.heart_fill, color: primaryColor, size: 40),
                    const AppText(text: appName, fontWeight: FontWeight.bold, fontSize: 32),
                  ],
                ),
              ),
            ),
          if (!isMobile)
            Row(
              children: List.generate(menuItems.length, (i) => TextButton(
                onPressed: () {
                  if (_routes[i].isNotEmpty) {
                    Navigator.pushNamed(context, _routes[i]);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AppText(
                    text: menuItems[i],
                    fontWeight: index == i ? FontWeight.bold : FontWeight.w500,
                    fontSize: 18,
                    color: index == i ? primaryColor : Colors.black54,
                  ),
                ),
              )),
            ),
          Row(
            children: [
              // Panier avec badge
              Stack(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, cartRoute),
                    icon: const Icon(IconlyLight.buy, color: Colors.black54),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      hoverColor: primaryColor,
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
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
              if (auth.isAuthenticated) ...[
                PopupMenuButton<String>(
                  offset: const Offset(0, 45),
                  onSelected: (value) {
                    switch (value) {
                      case 'profile':
                        Navigator.pushNamed(context, profileRoute);
                        break;
                      case 'bookings':
                        Navigator.pushNamed(context, bookingsRoute);
                        break;
                      case 'logout':
                        auth.logout();
                        Navigator.pushNamedAndRemoveUntil(context, homeRoute, (_) => false);
                        break;
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'profile', child: Text('Mon profil')),
                    const PopupMenuItem(value: 'bookings', child: Text('Mes réservations')),
                    const PopupMenuDivider(),
                    const PopupMenuItem(value: 'logout', child: Text('Déconnexion')),
                  ],
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: primaryColor.withValues(alpha: 0.15),
                    child: Text(
                      (auth.user?.displayName ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ] else
                AppButton(
                  text: 'Se connecter',
                  onPressed: () => Navigator.pushNamed(context, loginRoute),
                ),
            ],
          ),
        ],
      );
    });
  }
}
