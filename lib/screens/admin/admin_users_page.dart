import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/routes.dart';
import '../../providers/admin_provider.dart';
import 'admin_layout.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  String _search = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Utilisateurs',
      currentRoute: adminUsersRoute,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final admin = context.watch<AdminProvider>();

    if (admin.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = admin.users.where((u) {
      if (_search.isEmpty) return true;
      return u.displayName.toLowerCase().contains(_search.toLowerCase()) ||
          u.email.toLowerCase().contains(_search.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un utilisateur...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('${filtered.length} utilisateur(s)', style: GoogleFonts.montserrat(color: Colors.grey[600])),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final u = filtered[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: u.isAdmin ? Colors.amber.withValues(alpha: 0.2) : primaryColor.withValues(alpha: 0.1),
                    child: Text(
                      (u.displayName.isNotEmpty ? u.displayName[0] : 'U').toUpperCase(),
                      style: TextStyle(color: u.isAdmin ? Colors.amber[800] : primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(child: Text(u.displayName.isNotEmpty ? u.displayName : 'Sans nom', style: GoogleFonts.montserrat(fontWeight: FontWeight.w600))),
                      if (u.isAdmin)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                          child: Text('Admin', style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.amber[800])),
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.email, style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey)),
                      Text(
                        'Inscrit le ${DateFormat('dd/MM/yyyy').format(u.createdAt)}',
                        style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) => _handleAction(action, u),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: u.isAdmin ? 'demote' : 'promote',
                        child: Row(
                          children: [
                            Icon(u.isAdmin ? Icons.remove_moderator_outlined : Icons.admin_panel_settings_outlined, size: 18),
                            const SizedBox(width: 8),
                            Text(u.isAdmin ? 'Retirer admin' : 'Promouvoir admin'),
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

  void _handleAction(String action, user) async {
    final admin = context.read<AdminProvider>();
    if (action == 'promote') {
      await admin.updateUserRole(user.id, 'admin');
    } else if (action == 'demote') {
      await admin.updateUserRole(user.id, 'user');
    }
  }
}
