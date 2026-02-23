import '../core/constants.dart';
import '../core/models.dart';
import '../services/supabase_service.dart';

class UserRepository {
  final SupabaseService _db;

  UserRepository(this._db);

  Future<UserModel?> getUser(String uid) async {
    final data = await _db.getById(Tables.profiles, uid);
    if (data == null) return null;
    data['email'] = '';
    return UserModel.fromJson(data);
  }

  Future<void> createUser(UserModel user) async {
    await _db.upsert(Tables.profiles, user.toJson());
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.update(Tables.profiles, uid, data);
  }

  // ── Favoris ──

  Future<List<ProviderModel>> getFavorites(String userId) async {
    final data = await _db.getAll(
      Tables.favorites,
      select: '*, providers(*)',
      filters: {'user_id': userId},
    );
    return data
        .where((f) => f['providers'] != null)
        .map((f) => ProviderModel.fromJson(f['providers'] as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> getFavoriteIds(String userId) async {
    final data = await _db.getAll(
      Tables.favorites,
      select: 'provider_id',
      filters: {'user_id': userId},
    );
    return data.map((f) => f['provider_id'] as String).toList();
  }

  Future<void> addFavorite(String userId, String providerId) async {
    await _db.upsert(Tables.favorites, {
      'user_id': userId,
      'provider_id': providerId,
    });
  }

  Future<void> removeFavorite(String userId, String providerId) async {
    await _db.deleteWhere(Tables.favorites, {
      'user_id': userId,
      'provider_id': providerId,
    });
  }

  Future<bool> isFavorite(String userId, String providerId) async {
    final ids = await getFavoriteIds(userId);
    return ids.contains(providerId);
  }
}
