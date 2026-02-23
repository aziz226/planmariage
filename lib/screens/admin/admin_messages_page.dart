import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/routes.dart';
import '../../providers/admin_provider.dart';
import 'admin_layout.dart';

class AdminMessagesPage extends StatefulWidget {
  const AdminMessagesPage({super.key});

  @override
  State<AdminMessagesPage> createState() => _AdminMessagesPageState();
}

class _AdminMessagesPageState extends State<AdminMessagesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Messages',
      currentRoute: adminMessagesRoute,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final admin = context.watch<AdminProvider>();

    if (admin.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (admin.messages.isEmpty) {
      return Center(child: Text('Aucun message', style: GoogleFonts.montserrat(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: admin.messages.length,
      itemBuilder: (_, i) {
        final m = admin.messages[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: primaryColor.withValues(alpha: 0.1),
              child: Icon(Icons.email_outlined, color: primaryColor, size: 20),
            ),
            title: Text(m.name, style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
            subtitle: Text(
              m.createdAt != null ? DateFormat('dd/MM/yyyy HH:mm').format(m.createdAt!) : '',
              style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(Icons.email_outlined, m.email),
                    if (m.phone != null && m.phone!.isNotEmpty) _infoRow(Icons.phone_outlined, m.phone!),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(m.message, style: GoogleFonts.montserrat(fontSize: 14, height: 1.5)),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _deleteMessage(m.id!, m.name),
                        icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                        label: Text('Supprimer', style: GoogleFonts.montserrat(color: Colors.red, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.montserrat(fontSize: 13, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Future<void> _deleteMessage(String id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer ce message ?'),
        content: Text('Le message de $name sera supprimé.'),
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
      await context.read<AdminProvider>().deleteMessage(id);
    }
  }
}
