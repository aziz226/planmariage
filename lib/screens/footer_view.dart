import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/data.dart';
import '../core/variable_name.dart';
import '../widgets/app_text.dart';

class FooterView extends StatelessWidget {
  const FooterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, screenSize) {
      final isMobile = screenSize.isMobile;

      return Container(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 20),
          child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        ),
      );
    });
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 350, child: _buildBrandColumn()),
            _buildServicesColumn(),
            _buildSupportColumn(),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(color: Colors.white24),
        const SizedBox(height: 10),
        const AppText(
          text: '\u00a9 2025 Plan Mariage. Tous droits r\u00e9serv\u00e9s.',
          color: Colors.white54,
          fontSize: 13,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrandColumn(),
        const SizedBox(height: 24),
        _buildServicesColumn(),
        const SizedBox(height: 24),
        _buildSupportColumn(),
        const SizedBox(height: 20),
        const Divider(color: Colors.white24),
        const SizedBox(height: 10),
        const Center(
          child: AppText(
            text: '\u00a9 2025 Plan Mariage. Tous droits r\u00e9serv\u00e9s.',
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBrandColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(CupertinoIcons.heart_fill, color: primaryColor, size: 32),
            SizedBox(width: 4),
            AppText(text: appName, fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ],
        ),
        const SizedBox(height: 12),
        const AppText(
          text: "La plateforme de r\u00e9f\u00e9rence pour organiser votre mariage de r\u00eave. Plus de 1000 prestataires s\u00e9lectionn\u00e9s pour vous accompagner.",
          fontWeight: FontWeight.bold,
          color: Colors.white,
          overflow: TextOverflow.clip,
        ),
        const SizedBox(height: 16),
        const _ContactRow(icon: IconlyLight.call, text: '+226 70 90 00 00'),
        const SizedBox(height: 5),
        const _ContactRow(icon: IconlyLight.message, text: 'diversshoot@gmail.com'),
        const SizedBox(height: 5),
        const _ContactRow(icon: IconlyLight.location, text: 'Ouagadougou, Burkina Faso'),
      ],
    );
  }

  Widget _buildServicesColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(text: "Services", fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        const SizedBox(height: 12),
        ...services.map((s) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AppText(text: s.title, color: Colors.white),
        )),
      ],
    );
  }

  Widget _buildSupportColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(text: "Aide & Support", fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        const SizedBox(height: 12),
        ...supportLinks.map((s) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AppText(text: s, color: Colors.white),
        )),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: primaryColor, size: 18),
        const SizedBox(width: 8),
        AppText(text: text, color: Colors.white, fontSize: 13),
      ],
    );
  }
}
