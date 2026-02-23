import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/routes.dart';
import '../../providers/admin_provider.dart';
import 'admin_layout.dart';

class AdminProvidersPage extends StatefulWidget {
  const AdminProvidersPage({super.key});

  @override
  State<AdminProvidersPage> createState() => _AdminProvidersPageState();
}

class _AdminProvidersPageState extends State<AdminProvidersPage> {
  String _search = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadProviders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Prestataires',
      currentRoute: adminProvidersRoute,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final admin = context.watch<AdminProvider>();

    if (admin.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = admin.providers.where((p) {
      if (_search.isEmpty) return true;
      return p.name.toLowerCase().contains(_search.toLowerCase()) ||
          p.serviceCategory.toLowerCase().contains(_search.toLowerCase());
    }).toList();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un prestataire...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),
        // Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text('${filtered.length} prestataire(s)', style: GoogleFonts.montserrat(color: Colors.grey[600])),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showProviderDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Ajouter'),
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final p = filtered[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    child: Text(p.name[0].toUpperCase(), style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                  ),
                  title: Row(
                    children: [
                      Expanded(child: Text(p.name, style: GoogleFonts.montserrat(fontWeight: FontWeight.w600))),
                      if (p.isVerified) const Icon(Icons.verified, color: Colors.blue, size: 18),
                    ],
                  ),
                  subtitle: Text('${p.serviceCategory} • ${p.ville}', style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey)),
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) => _handleAction(action, p),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: p.isVerified ? 'unverify' : 'verify',
                        child: Row(
                          children: [
                            Icon(p.isVerified ? Icons.cancel_outlined : Icons.verified_outlined, size: 18),
                            const SizedBox(width: 8),
                            Text(p.isVerified ? 'Retirer vérification' : 'Vérifier'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Supprimer', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
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

  void _handleAction(String action, provider) async {
    final admin = context.read<AdminProvider>();
    if (action == 'verify') {
      await admin.updateProvider(provider.id, {'is_verified': true});
    } else if (action == 'unverify') {
      await admin.updateProvider(provider.id, {'is_verified': false});
    } else if (action == 'delete') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Supprimer ce prestataire ?'),
          content: Text('${provider.name} sera définitivement supprimé.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      if (confirm == true && mounted) {
        await admin.deleteProvider(provider.id);
      }
    }
  }

  void _showProviderDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    final villeCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nouveau prestataire'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom')),
              const SizedBox(height: 8),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
              const SizedBox(height: 8),
              TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'Catégorie de service')),
              const SizedBox(height: 8),
              TextField(controller: villeCtrl, decoration: const InputDecoration(labelText: 'Ville')),
              const SizedBox(height: 8),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Prix à partir de'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty || categoryCtrl.text.isEmpty || villeCtrl.text.isEmpty) return;
              final ok = await context.read<AdminProvider>().createProvider({
                'name': nameCtrl.text.trim(),
                'description': descCtrl.text.trim(),
                'service_category': categoryCtrl.text.trim(),
                'ville': villeCtrl.text.trim(),
                'price_from': int.tryParse(priceCtrl.text.trim()) ?? 0,
              });
              if (ok && mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}
