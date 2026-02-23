import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/routes.dart';
import '../../providers/admin_provider.dart';
import 'admin_layout.dart';

class AdminBookingsPage extends StatefulWidget {
  const AdminBookingsPage({super.key});

  @override
  State<AdminBookingsPage> createState() => _AdminBookingsPageState();
}

class _AdminBookingsPageState extends State<AdminBookingsPage> {
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Réservations',
      currentRoute: adminBookingsRoute,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final admin = context.watch<AdminProvider>();

    if (admin.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = admin.bookings.where((b) {
      if (_statusFilter == 'all') return true;
      return b.status == _statusFilter;
    }).toList();

    return Column(
      children: [
        // Filters
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _filterChip('Tous', 'all'),
              const SizedBox(width: 8),
              _filterChip('En attente', 'pending'),
              const SizedBox(width: 8),
              _filterChip('Confirmés', 'confirmed'),
              const SizedBox(width: 8),
              _filterChip('Annulés', 'cancelled'),
              const Spacer(),
              Text('${filtered.length} résultat(s)', style: GoogleFonts.montserrat(color: Colors.grey[600], fontSize: 13)),
            ],
          ),
        ),
        // List
        Expanded(
          child: filtered.isEmpty
              ? Center(child: Text('Aucune réservation', style: GoogleFonts.montserrat(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final b = filtered[i];
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
                                    b.provider?.name ?? b.packTitle ?? 'Réservation #${b.id.substring(0, 8)}',
                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ),
                                _statusBadge(b.status),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('dd/MM/yyyy HH:mm').format(b.createdAt),
                                  style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey[600]),
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.attach_money, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  _formatPrice(b.totalPrice),
                                  style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: primaryColor),
                                ),
                              ],
                            ),
                            if (b.status == 'pending') ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: () => _updateStatus(b.id, 'cancelled'),
                                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                                    child: const Text('Annuler'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => _updateStatus(b.id, 'confirmed'),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                    child: const Text('Confirmer'),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _filterChip(String label, String value) {
    final isActive = _statusFilter == value;
    return FilterChip(
      label: Text(label, style: GoogleFonts.montserrat(fontSize: 12, color: isActive ? Colors.white : Colors.grey[700])),
      selected: isActive,
      onSelected: (_) => setState(() => _statusFilter = value),
      selectedColor: primaryColor,
      checkmarkColor: Colors.white,
    );
  }

  Widget _statusBadge(String status) {
    final color = status == 'confirmed' ? Colors.green : status == 'cancelled' ? Colors.red : Colors.orange;
    final label = status == 'confirmed' ? 'Confirmé' : status == 'cancelled' ? 'Annulé' : 'En attente';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: GoogleFonts.montserrat(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Future<void> _updateStatus(String id, String status) async {
    await context.read<AdminProvider>().updateBookingStatus(id, status);
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
