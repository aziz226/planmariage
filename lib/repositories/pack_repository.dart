import '../core/constants.dart';
import '../core/models.dart';
import '../services/supabase_service.dart';

class PackRepository {
  final SupabaseService _db;

  PackRepository(this._db);

  /// Get all packs for a specific provider (with join)
  Future<List<PackModel>> getProviderPacks(String providerId) async {
    final response = await _db.client
        .from(Tables.packs)
        .select('*, providers(name)')
        .eq('provider_id', providerId)
        .order('price', ascending: true);

    return (response as List)
        .map((j) => PackModel.fromJson(Map<String, dynamic>.from(j)))
        .toList();
  }

  /// Get all packs
  Future<List<PackModel>> getAllPacks({int? limit}) async {
    var query = _db.client
        .from(Tables.packs)
        .select('*, providers(name)')
        .order('price', ascending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final response = await query;
    return (response as List)
        .map((j) => PackModel.fromJson(Map<String, dynamic>.from(j)))
        .toList();
  }
}
