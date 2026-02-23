import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/admin_guard.dart';

class AdminLayout extends StatelessWidget {
  final String title;
  final String currentRoute;
  final Widget child;

  const AdminLayout({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.child,
  });

  static const _menuItems = [
    _MenuItem('Dashboard', Icons.dashboard_outlined, adminDashboardRoute),
    _MenuItem('Prestataires', Icons.store_outlined, adminProvidersRoute),
    _MenuItem('Réservations', Icons.receipt_long_outlined, adminBookingsRoute),
    _MenuItem('Avis', Icons.star_outline, adminReviewsRoute),
    _MenuItem('Catégories', Icons.category_outlined, adminCategoriesRoute),
    _MenuItem('Utilisateurs', Icons.people_outline, adminUsersRoute),
    _MenuItem('Messages', Icons.email_outlined, adminMessagesRoute),
    _MenuItem('Abonnements', Icons.card_membership_outlined, adminSubscriptionsRoute),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return AdminGuard(
      child: Scaffold(
        appBar: isMobile
            ? AppBar(
                title: Text(title, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Déconnexion',
                    onPressed: () async {
                      await context.read<AuthProvider>().logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, loginRoute, (_) => false);
                      }
                    },
                  ),
                ],
              )
            : null,
        drawer: isMobile ? _buildDrawer(context) : null,
        body: isMobile
            ? child
            : Row(
                children: [
                  _buildSidebar(context),
                  Expanded(
                    child: Column(
                      children: [
                        _buildTopBar(context),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 260,
      color: const Color(0xFF1E1E2D),
      child: Column(
        children: [
          // Logo / Titre
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              'Plan Mariage',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 8),
          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _menuItems.map((item) => _buildNavItem(context, item)).toList(),
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          // Déconnexion
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white70, size: 20),
            title: Text('Déconnexion', style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 13)),
            onTap: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, loginRoute, (_) => false);
              }
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, _MenuItem item) {
    final isActive = currentRoute == item.route;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? primaryColor.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(item.icon, color: isActive ? primaryColor : Colors.white70, size: 20),
        title: Text(
          item.label,
          style: GoogleFonts.montserrat(
            color: isActive ? primaryColor : Colors.white70,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        onTap: isActive ? null : () => Navigator.pushReplacementNamed(context, item.route),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Text(title, style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(
            auth.user?.displayName ?? 'Admin',
            style: GoogleFonts.montserrat(color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: primaryColor.withValues(alpha: 0.15),
            child: Text(
              (auth.user?.displayName ?? 'A')[0].toUpperCase(),
              style: GoogleFonts.montserrat(color: primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF1E1E2D),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Plan Mariage Admin',
                  style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: _menuItems.map((item) => _buildNavItem(context, item)).toList(),
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white70, size: 20),
                title: Text('Déconnexion', style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 13)),
                onTap: () async {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, loginRoute, (_) => false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final String label;
  final IconData icon;
  final String route;
  const _MenuItem(this.label, this.icon, this.route);
}
