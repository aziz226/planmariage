import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/models.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../widgets/auth_guard.dart';
import '../widgets/header.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.uid != null) {
        context.read<BookingProvider>().loadBookings(auth.uid!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingProv = context.watch<BookingProvider>();

    return AuthGuard(
      child: ResponsiveBuilder(builder: (context, screenSize) {
        final isMobile = screenSize.isMobile;
        final padding = isMobile ? 16.0 : 24.0;

        return Scaffold(
          body: Column(
            children: [
              const Header(index: -1),
              Expanded(
                child: bookingProv.loading
                    ? const Center(child: CircularProgressIndicator())
                    : bookingProv.bookings.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.receipt_long_outlined, size: isMobile ? 60 : 80, color: Colors.grey[300]),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Aucune réservation',
                                    style: GoogleFonts.montserrat(fontSize: isMobile ? 18 : 20, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: EdgeInsets.all(padding),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 800),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mes réservations',
                                      style: GoogleFonts.montserrat(fontSize: isMobile ? 22 : 28, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 20),
                                    ...bookingProv.bookings.map((b) => _BookingCard(
                                          booking: b,
                                          onCancel: () => _cancel(b.id),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _cancel(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Annuler la réservation ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Non')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Oui, annuler', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await context.read<BookingProvider>().cancelBooking(id);
    }
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onCancel;

  const _BookingCard({required this.booking, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(booking.status);
    final statusLabel = _statusLabel(booking.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.provider?.name ?? booking.packTitle ?? 'Réservation',
                    style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: GoogleFonts.montserrat(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (booking.provider != null)
              _infoRow(Icons.category_outlined, booking.provider!.serviceCategory),
            if (booking.eventDate != null)
              _infoRow(Icons.calendar_today, DateFormat('dd MMMM yyyy', 'fr_FR').format(booking.eventDate!)),
            if (booking.paymentMethod != null)
              _infoRow(Icons.payment, booking.paymentMethod == 'mobile_money' ? 'Mobile Money' : 'Carte bancaire'),
            _infoRow(Icons.attach_money, _formatPrice(booking.totalPrice)),
            _infoRow(Icons.access_time, DateFormat('dd/MM/yyyy HH:mm').format(booking.createdAt)),
            if (booking.notes != null && booking.notes!.isNotEmpty)
              _infoRow(Icons.notes, booking.notes!),
            if (booking.status == 'pending') ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 18),
                  label: Text('Annuler', style: GoogleFonts.montserrat(color: Colors.red)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey[700]))),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'confirmed':
        return 'Confirmé';
      case 'cancelled':
        return 'Annulé';
      default:
        return status;
    }
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
