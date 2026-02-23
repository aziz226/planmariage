import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/routes.dart';
import '../../providers/admin_provider.dart';
import 'admin_layout.dart';

class AdminCategoriesPage extends StatefulWidget {
  const AdminCategoriesPage({super.key});

  @override
  State<AdminCategoriesPage> createState() => _AdminCategoriesPageState();
}

class _AdminCategoriesPageState extends State<AdminCategoriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Catégories',
      currentRoute: adminCategoriesRoute,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final admin = context.watch<AdminProvider>();

    if (admin.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('${admin.categories.length} catégorie(s)', style: GoogleFonts.montserrat(color: Colors.grey[600])),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showCategoryDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Ajouter'),
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
        Expanded(
          child: admin.categories.isEmpty
              ? Center(child: Text('Aucune catégorie', style: GoogleFonts.montserrat(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: admin.categories.length,
                  itemBuilder: (_, i) {
                    final c = admin.categories[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          child: Icon(c.iconData, color: primaryColor, size: 20),
                        ),
                        title: Text(c.name, style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
                        subtitle: Text('${c.providerCount} prestataire(s)', style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              onPressed: () => _showCategoryDialog(category: c),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                              onPressed: () => _deleteCategory(c.id, c.name),
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

  void _showCategoryDialog({dynamic category}) {
    final nameCtrl = TextEditingController(text: category?.name ?? '');
    final iconCtrl = TextEditingController(text: category?.icon ?? '');
    final isEdit = category != null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Modifier la catégorie' : 'Nouvelle catégorie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom')),
            const SizedBox(height: 8),
            TextField(
              controller: iconCtrl,
              decoration: const InputDecoration(
                labelText: 'Icône (ex: camera, music_note, cake)',
                helperText: 'Nom de l\'icône Material',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty) return;
              final data = {
                'name': nameCtrl.text.trim(),
                if (iconCtrl.text.isNotEmpty) 'icon': iconCtrl.text.trim(),
              };
              bool ok;
              if (isEdit) {
                ok = await context.read<AdminProvider>().updateCategory(category.id, data);
              } else {
                ok = await context.read<AdminProvider>().createCategory(data);
              }
              if (ok && mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
            child: Text(isEdit ? 'Modifier' : 'Créer'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(String id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer cette catégorie ?'),
        content: Text('$name sera définitivement supprimé.'),
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
      await context.read<AdminProvider>().deleteCategory(id);
    }
  }
}
