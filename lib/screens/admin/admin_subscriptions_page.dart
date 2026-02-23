import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/routes.dart';
import '../../providers/admin_provider.dart';
import 'admin_layout.dart';

class AdminSubscriptionsPage extends StatefulWidget {
  const AdminSubscriptionsPage({super.key});

  @override
  State<AdminSubscriptionsPage> createState() => _AdminSubscriptionsPageState();
}

class _AdminSubscriptionsPageState extends State<AdminSubscriptionsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadSubscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Abonnements',
      currentRoute: adminSubscriptionsRoute,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final admin = context.watch<AdminProvider>();

    if (admin.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (admin.subscriptions.isEmpty) {
      return Center(child: Text('Aucun abonnement', style: GoogleFonts.montserrat(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: admin.subscriptions.length,
      itemBuilder: (_, i) {
        final s = admin.subscriptions[i];
        final isActive = s.status == 'active' && s.endDate.isAfter(DateTime.now());
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        s.provider?.name ?? 'Prestataire #${s.providerId.substring(0, 8)}',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green.withValues(alpha: 0.15) : Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isActive ? 'Actif' : 'Expiré',
                        style: GoogleFonts.montserrat(
                          color: isActive ? Colors.green : Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _chip(Icons.card_membership_outlined, s.planType),
                    const SizedBox(width: 12),
                    _chip(Icons.attach_money, _formatPrice(s.price)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.date_range, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${DateFormat('dd/MM/yyyy').format(s.startDate)} → ${DateFormat('dd/MM/yyyy').format(s.endDate)}',
                      style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: primaryColor),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.montserrat(fontSize: 12, color: primaryColor, fontWeight: FontWeight.w600)),
      ],
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
