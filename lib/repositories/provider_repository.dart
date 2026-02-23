import '../core/constants.dart';
import '../core/models.dart';
import '../services/supabase_service.dart';

class ProviderRepository {
  final SupabaseService _db;

  ProviderRepository(this._db);

  Future<List<ProviderModel>> getProviders({
    String? serviceCategory,
    String? ville,
    String? searchQuery,
    String orderBy = 'created_at',
    bool ascending = false,
    int? limit,
  }) async {
    final filters = <String, dynamic>{};
    if (serviceCategory != null) filters['service_category'] = serviceCategory;
    if (ville != null) filters['ville'] = ville;

    final data = await _db.getAll(
      Tables.providers,
      filters: filters.isNotEmpty ? filters : null,
      ilikeColumn: searchQuery != null ? 'name' : null,
      ilike: searchQuery,
      orderBy: orderBy,
      ascending: ascending,
      limit: limit,
    );

    return data.map((json) => ProviderModel.fromJson(json)).toList();
  }

  Future<ProviderModel?> getById(String id) async {
    final data = await _db.getById(Tables.providers, id);
    if (data == null) return null;
    return ProviderModel.fromJson(data);
  }

  Future<List<ProviderModel>> getByCategory(String category, {int? limit}) async {
    return getProviders(serviceCategory: category, limit: limit);
  }

  Future<List<ProviderModel>> search(String query) async {
    return getProviders(searchQuery: query);
  }
}
