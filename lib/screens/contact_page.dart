import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_colors.dart';
import '../core/constants.dart';
import '../core/models.dart';
import '../widgets/header.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);
    try {
      final msg = ContactMessage(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        message: _messageCtrl.text.trim(),
      );
      await Supabase.instance.client.from(Tables.contactMessages).insert(msg.toJson());

      if (!mounted) return;
      _nameCtrl.clear();
      _emailCtrl.clear();
      _phoneCtrl.clear();
      _messageCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message envoyé avec succès !'), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    }
    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, screenSize) {
      final isMobile = screenSize.isMobile;
      final padding = isMobile ? 16.0 : 24.0;

      return Scaffold(
        body: Column(
          children: [
            const Header(index: 3),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: isMobile
                        ? Column(
                            children: [
                              _buildInfo(isMobile),
                              const SizedBox(height: 32),
                              _buildForm(),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildInfo(isMobile)),
                              const SizedBox(width: 40),
                              Expanded(child: _buildForm()),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfo(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contactez-nous',
          style: GoogleFonts.montserrat(fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'Vous avez une question, une demande de devis ou besoin d\'aide pour organiser votre mariage ? '
          'Notre équipe est là pour vous accompagner.',
          style: GoogleFonts.montserrat(fontSize: 15, color: Colors.grey[600], height: 1.6),
        ),
        const SizedBox(height: 32),
        _contactInfoTile(Icons.location_on_outlined, 'Adresse', 'Ouagadougou, Burkina Faso'),
        _contactInfoTile(Icons.email_outlined, 'Email', 'contact@planmariage.bf'),
        _contactInfoTile(Icons.phone_outlined, 'Téléphone', '+226 70 00 00 00'),
        _contactInfoTile(Icons.access_time, 'Horaires', 'Lun - Ven : 8h - 18h'),
      ],
    );
  }

  Widget _contactInfoTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
              Text(subtitle, style: GoogleFonts.montserrat(color: Colors.grey[600], fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Envoyer un message', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameCtrl,
                decoration: _dec('Nom complet', Icons.person_outline),
                validator: (v) => (v == null || v.isEmpty) ? 'Nom requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: _dec('Email', Icons.email_outlined),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email requis';
                  if (!v.contains('@')) return 'Email invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: _dec('Téléphone (optionnel)', Icons.phone_outlined),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageCtrl,
                maxLines: 5,
                decoration: _dec('Votre message', Icons.message_outlined),
                validator: (v) => (v == null || v.isEmpty) ? 'Message requis' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _sending ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _sending
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Envoyer', style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    );
  }
}
