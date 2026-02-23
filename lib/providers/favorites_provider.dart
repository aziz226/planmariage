import 'package:flutter/foundation.dart';

import '../core/models.dart';
import '../repositories/user_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  final UserRepository _userRepo;

  FavoritesProvider(this._userRepo);

  List<ProviderModel> _favorites = [];
  final Set<String> _favoriteIds = {};
  bool _loading = false;
  String? _error;

  List<ProviderModel> get favorites => _favorites;
  Set<String> get favoriteIds => _favoriteIds;
  bool get loading => _loading;
  String? get error => _error;

  bool isFavorite(String providerId) => _favoriteIds.contains(providerId);

  Future<void> loadFavorites(String userId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _favorites = await _userRepo.getFavorites(userId);
      _favoriteIds.clear();
      _favoriteIds.addAll(_favorites.map((p) => p.id));
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> loadFavoriteIds(String userId) async {
    try {
      final ids = await _userRepo.getFavoriteIds(userId);
      _favoriteIds.clear();
      _favoriteIds.addAll(ids);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggleFavorite(String userId, String providerId) async {
    final wasFavorite = _favoriteIds.contains(providerId);

    // Optimistic update
    if (wasFavorite) {
      _favoriteIds.remove(providerId);
      _favorites.removeWhere((p) => p.id == providerId);
    } else {
      _favoriteIds.add(providerId);
    }
    notifyListeners();

    try {
      if (wasFavorite) {
        await _userRepo.removeFavorite(userId, providerId);
      } else {
        await _userRepo.addFavorite(userId, providerId);
      }
    } catch (e) {
      // Rollback on error
      if (wasFavorite) {
        _favoriteIds.add(providerId);
      } else {
        _favoriteIds.remove(providerId);
      }
      _error = e.toString();
      notifyListeners();
    }
  }
}
