import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/routes.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/auth_guard.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/header.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'mobile_money';
  final _notesCtrl = TextEditingController();
  DateTime? _eventDate;
  bool _processing = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date != null) setState(() => _eventDate = date);
  }

  Future<void> _confirm() async {
    final auth = context.read<AuthProvider>();
    final cart = context.read<CartProvider>();
    final bookingProv = context.read<BookingProvider>();

    if (!auth.isAuthenticated) {
      Navigator.pushNamed(context, loginRoute);
      return;
    }

    setState(() => _processing = true);

    // Créer une réservation pour chaque article du panier
    bool allOk = true;
    for (final item in cart.items) {
      final booking = await bookingProv.createBooking(
        userId: auth.uid!,
        providerId: item.provider?.id,
        packTitle: item.pack?.name,
        eventDate: _eventDate,
        totalPrice: item.price,
        paymentMethod: _paymentMethod,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
      if (booking == null) allOk = false;
    }

    if (!mounted) return;
    setState(() => _processing = false);

    if (allOk) {
      cart.clear();
      _showSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bookingProv.error ?? 'Erreur'), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            Text(
              'Commande confirmée !',
              style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Votre réservation a été enregistrée. Vous recevrez une confirmation par email.',
              style: GoogleFonts.montserrat(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(context, bookingsRoute, (_) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              child: const Text('Voir mes réservations'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(context, homeRoute, (_) => false);
              },
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return AuthGuard(
      child: Scaffold(
        body: Column(
          children: [
            const Header(index: -1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Paiement', style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),

                        // Récap commande
                        Text('Récapitulatif', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        ...cart.items.map((item) => CartItemWidget(item: item)),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(cart.totalFormatted, style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Date événement
                        Text('Date de l\'événement', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[400]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  _eventDate != null
                                      ? '${_eventDate!.day}/${_eventDate!.month}/${_eventDate!.year}'
                                      : 'Sélectionner une date',
                                  style: GoogleFonts.montserrat(
                                    color: _eventDate != null ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Mode de paiement
                        Text('Mode de paiement', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        _paymentOption('mobile_money', 'Mobile Money', 'Orange Money, Moov Money', Icons.phone_android),
                        _paymentOption('card', 'Carte bancaire', 'Visa, Mastercard', Icons.credit_card),
                        const SizedBox(height: 24),

                        // Notes
                        TextField(
                          controller: _notesCtrl,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Notes (optionnel)',
                            hintText: 'Précisions sur votre événement...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Bouton confirmer
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _processing || cart.isEmpty ? null : _confirm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: _processing
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : Text('Confirmer la commande', style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentOption(String value, String title, String subtitle, IconData icon) {
    return RadioListTile<String>(
      value: value,
      groupValue: _paymentMethod,
      onChanged: (v) => setState(() => _paymentMethod = v!),
      activeColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Row(
        children: [
          Icon(icon, size: 20, color: _paymentMethod == value ? primaryColor : Colors.grey),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
              Text(subtitle, style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
