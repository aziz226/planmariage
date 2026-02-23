import 'package:flutter/foundation.dart';

import '../core/models.dart';
import '../repositories/review_repository.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewRepository _repo;

  ReviewProvider(this._repo);

  List<ReviewModel> _reviews = [];
  bool _loading = false;
  String? _error;

  // ── Getters ──

  List<ReviewModel> get reviews => _reviews;
  bool get loading => _loading;
  String? get error => _error;
  int get reviewCount => _reviews.length;

  double get averageRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        _reviews.length;
  }

  // ── Actions ──

  Future<void> loadReviews(String providerId) async {
    _setLoading(true);
    _error = null;
    try {
      _reviews = await _repo.getProviderReviews(providerId);
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> addReview({
    required String userId,
    required String providerId,
    required int rating,
    String? comment,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final review = ReviewModel(
        id: '',
        userId: userId,
        providerId: providerId,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );
      final created = await _repo.addReview(review);
      _reviews.insert(0, created);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void clearReviews() {
    _reviews = [];
    notifyListeners();
  }

  // ── Helpers ──

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
