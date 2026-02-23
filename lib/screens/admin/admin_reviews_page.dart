import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/routes.dart';
import '../../providers/admin_provider.dart';
import '../../widgets/rating_stars.dart';
import 'admin_layout.dart';

class AdminReviewsPage extends StatefulWidget {
  const AdminReviewsPage({super.key});

  @override
  State<AdminReviewsPage> createState() => _AdminReviewsPageState();
}

class _AdminReviewsPageState extends State<AdminReviewsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Avis',
      currentRoute: adminReviewsRoute,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final admin = context.watch<AdminProvider>();

    if (admin.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (admin.reviews.isEmpty) {
      return Center(child: Text('Aucun avis', style: GoogleFonts.montserrat(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: admin.reviews.length,
      itemBuilder: (_, i) {
        final r = admin.reviews[i];
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
                    RatingStars(rating: r.rating.toDouble(), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r.userName ?? 'Anonyme',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(r.createdAt),
                      style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                if (r.comment != null && r.comment!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(r.comment!, style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey[700])),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Provider ID: ${r.providerId.substring(0, 8)}...',
                      style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => _deleteReview(r.id),
                      icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                      label: Text('Supprimer', style: GoogleFonts.montserrat(color: Colors.red, fontSize: 12)),
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

  Future<void> _deleteReview(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer cet avis ?'),
        content: const Text('Cette action est irréversible.'),
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
      await context.read<AdminProvider>().deleteReview(id);
    }
  }
}
