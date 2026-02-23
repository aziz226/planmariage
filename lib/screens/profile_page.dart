import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/data.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_guard.dart';
import '../widgets/header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  String? _selectedVille;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameCtrl = TextEditingController(text: user?.displayName ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _selectedVille = user?.ville;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    await auth.updateProfile({
      'display_name': _nameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      'ville': _selectedVille,
    });

    if (!mounted) return;
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil mis à jour !'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: primaryColor.withValues(alpha: 0.15),
            child: Text(
              (user?.displayName ?? 'U')[0].toUpperCase(),
              style: GoogleFonts.montserrat(fontSize: 40, fontWeight: FontWeight.bold, color: primaryColor),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user?.email ?? '',
            style: GoogleFonts.montserrat(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // Nom
          TextFormField(
            controller: _nameCtrl,
            enabled: _editing,
            decoration: _dec('Nom complet', Icons.person_outline),
            validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
          ),
          const SizedBox(height: 16),

          // Téléphone
          TextFormField(
            controller: _phoneCtrl,
            enabled: _editing,
            keyboardType: TextInputType.phone,
            decoration: _dec('Téléphone', Icons.phone_outlined),
          ),
          const SizedBox(height: 16),

          // Ville
          DropdownButtonFormField<String>(
            value: _selectedVille,
            decoration: _dec('Ville', Icons.location_on_outlined),
            items: [
              const DropdownMenuItem<String>(value: null, child: Text('Non définie')),
              ...villes.map((v) => DropdownMenuItem(value: v, child: Text(v))),
            ],
            onChanged: _editing ? (v) => setState(() => _selectedVille = v) : null,
          ),
          const SizedBox(height: 24),

          // Boutons
          if (_editing)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _editing = false),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: auth.loading ? null : _save,
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                    child: auth.loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Enregistrer'),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _editing = true),
                icon: const Icon(Icons.edit),
                label: const Text('Modifier le profil'),
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              ),
            ),
        ],
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
