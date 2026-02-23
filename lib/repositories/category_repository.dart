import '../core/constants.dart';
import '../core/models.dart';
import '../services/supabase_service.dart';

class CategoryRepository {
  final SupabaseService _db;

  CategoryRepository(this._db);

  Future<List<CategoryModel>> getCategories() async {
    final data = await _db.getAll(
      Tables.categories,
      orderBy: 'name',
      ascending: true,
    );
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
