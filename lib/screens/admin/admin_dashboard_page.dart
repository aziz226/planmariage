import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/routes.dart';
import '../../providers/admin_provider.dart';
import 'admin_layout.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Dashboard',
      currentRoute: adminDashboardRoute,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final admin = context.watch<AdminProvider>();

    if (admin.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final stats = admin.stats;
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1000 ? 3 : 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards
          GridView.count(
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.2,
            children: [
              _StatCard(
                title: 'Prestataires',
                value: '${stats['totalProviders'] ?? 0}',
                icon: Icons.store_outlined,
                color: primaryColor,
              ),
              _StatCard(
                title: 'Réservations',
                value: '${stats['totalBookings'] ?? 0}',
                icon: Icons.receipt_long_outlined,
                color: Colors.blue,
                subtitle: '${stats['pendingBookings'] ?? 0} en attente',
              ),
              _StatCard(
                title: 'Utilisateurs',
                value: '${stats['totalUsers'] ?? 0}',
                icon: Icons.people_outline,
                color: Colors.green,
              ),
              _StatCard(
                title: 'Avis',
                value: '${stats['totalReviews'] ?? 0}',
                icon: Icons.star_outline,
                color: Colors.orange,
              ),
              _StatCard(
                title: 'Revenus confirmés',
                value: _formatPrice(stats['totalRevenue'] ?? 0),
                icon: Icons.attach_money,
                color: Colors.teal,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent bookings
          Text('Réservations récentes', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: admin.recentBookings.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Aucune réservation'),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: admin.recentBookings.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final b = admin.recentBookings[i];
                      return ListTile(
                        leading: _statusBadge(b.status),
                        title: Text(
                          b.provider?.name ?? b.packTitle ?? 'Réservation',
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(b.createdAt),
                          style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey),
                        ),
                        trailing: Text(
                          _formatPrice(b.totalPrice),
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final color = status == 'confirmed'
        ? Colors.green
        : status == 'cancelled'
            ? Colors.red
            : Colors.orange;
    final label = status == 'confirmed'
        ? 'Confirmé'
        : status == 'cancelled'
            ? 'Annulé'
            : 'En attente';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: GoogleFonts.montserrat(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(str[i]);
    }
    return '$buffer FCFA';
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.montserrat(fontSize: 13, color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text(value, style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold)),
                  if (subtitle != null)
                    Text(subtitle!, style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
