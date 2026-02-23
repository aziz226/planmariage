import '../core/constants.dart';
import '../core/models.dart';
import '../services/supabase_service.dart';

class ReviewRepository {
  final SupabaseService _db;

  ReviewRepository(this._db);

  Future<List<ReviewModel>> getProviderReviews(String providerId) async {
    final data = await _db.getAll(
      Tables.reviews,
      select: '*, profiles(display_name)',
      filters: {'provider_id': providerId},
      orderBy: 'created_at',
      ascending: false,
    );
    return data.map((json) => ReviewModel.fromJson(json)).toList();
  }

  Future<ReviewModel> addReview(ReviewModel review) async {
    final data = await _db.insert(
      Tables.reviews,
      review.toJson(),
      select: '*, profiles(display_name)',
    );

    // Mettre à jour la note moyenne du prestataire
    await _updateProviderRating(review.providerId);

    return ReviewModel.fromJson(data);
  }

  Future<void> _updateProviderRating(String providerId) async {
    final reviews = await getProviderReviews(providerId);
    if (reviews.isEmpty) return;

    final avgRating = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    await _db.update(Tables.providers, providerId, {
      'rating': double.parse(avgRating.toStringAsFixed(1)),
      'review_count': reviews.length,
    });
  }
}
