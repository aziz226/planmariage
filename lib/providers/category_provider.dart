import 'package:flutter/foundation.dart';

import '../core/models.dart';
import '../repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repo;

  CategoryProvider(this._repo);

  List<CategoryModel> _categories = [];
  bool _loading = false;
  String? _error;

  // -- Getters --

  List<CategoryModel> get categories => _categories;
  bool get loading => _loading;
  String? get error => _error;

  /// Liste des noms de catégories (pour les filtres dropdown).
  List<String> get categoryNames =>
      _categories.map((c) => c.name).toList();

  // -- Actions --

  Future<void> loadCategories() async {
    if (_categories.isNotEmpty) return; // déjà chargées
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _categories = await _repo.getCategories();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  /// Force le rechargement (ignore le cache).
  Future<void> refreshCategories() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _categories = await _repo.getCategories();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
}
