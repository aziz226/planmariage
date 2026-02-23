import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  SupabaseClient get client => _client;

  /// SELECT avec filtres optionnels
  Future<List<Map<String, dynamic>>> getAll(
    String table, {
    String? select,
    Map<String, dynamic>? filters,
    String? ilike,
    String? ilikeColumn,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    // Phase 1 : filtres (PostgrestFilterBuilder)
    var filterQuery = _client.from(table).select(select ?? '*');

    if (filters != null) {
      for (final entry in filters.entries) {
        if (entry.value != null) {
          filterQuery = filterQuery.eq(entry.key, entry.value);
        }
      }
    }

    if (ilike != null && ilikeColumn != null) {
      filterQuery = filterQuery.ilike(ilikeColumn, '%$ilike%');
    }

    // Phase 2 : transformations (PostgrestTransformBuilder)
    PostgrestTransformBuilder<List<Map<String, dynamic>>> transformQuery = filterQuery;

    if (orderBy != null) {
      transformQuery = transformQuery.order(orderBy, ascending: ascending);
    }

    if (limit != null) {
      transformQuery = transformQuery.limit(limit);
    }

    final response = await transformQuery;
    return List<Map<String, dynamic>>.from(response);
  }

  /// SELECT un seul enregistrement par ID
  Future<Map<String, dynamic>?> getById(String table, String id, {String? select}) async {
    final response = await _client
        .from(table)
        .select(select ?? '*')
        .eq('id', id)
        .maybeSingle();
    return response;
  }

  /// INSERT
  Future<Map<String, dynamic>> insert(String table, Map<String, dynamic> data, {String? select}) async {
    final response = await _client.from(table).insert(data).select(select ?? '*').single();
    return response;
  }

  /// UPDATE
  Future<void> update(String table, String id, Map<String, dynamic> data) async {
    await _client.from(table).update(data).eq('id', id);
  }

  /// DELETE
  Future<void> delete(String table, String id) async {
    await _client.from(table).delete().eq('id', id);
  }

  /// DELETE avec condition composée
  Future<void> deleteWhere(String table, Map<String, dynamic> conditions) async {
    var query = _client.from(table).delete();
    for (final entry in conditions.entries) {
      query = query.eq(entry.key, entry.value);
    }
    await query;
  }

  /// UPSERT
  Future<void> upsert(String table, Map<String, dynamic> data) async {
    await _client.from(table).upsert(data);
  }
}
