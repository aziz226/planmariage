import 'package:flutter/foundation.dart';

import '../core/models.dart';
import '../repositories/provider_repository.dart';

class ProvidersProvider extends ChangeNotifier {
  final ProviderRepository _repo;

  ProvidersProvider(this._repo);

  List<ProviderModel> _providers = [];
  List<ProviderModel> _featuredProviders = [];
  final Set<String> _featuredIds = {};
  ProviderModel? _selectedProvider;
  bool _loading = false;
  bool _featuredLoading = false;
  String? _error;

  // Filtres actifs
  String? _categoryFilter;
  String? _villeFilter;
  String? _searchQuery;
  String _sortBy = 'created_at';
  bool _sortAscending = false;

  // ── Getters ──

  List<ProviderModel> get providers => _providers;
  List<ProviderModel> get featuredProviders => _featuredProviders;
  Set<String> get featuredIds => _featuredIds;
  ProviderModel? get selectedProvider => _selectedProvider;
  bool get loading => _loading;
  bool get featuredLoading => _featuredLoading;
  String? get error => _error;
  String? get categoryFilter => _categoryFilter;
  String? get villeFilter => _villeFilter;
  String? get searchQuery => _searchQuery;

  // ── Chargement ──

  Future<void> loadProviders() async {
    _setLoading(true);
    _error = null;
    try {
      _providers = await _repo.getProviders(
        serviceCategory: _categoryFilter,
        ville: _villeFilter,
        searchQuery: _searchQuery,
        orderBy: _sortBy,
        ascending: _sortAscending,
      );
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> loadProviderById(String id) async {
    _setLoading(true);
    _error = null;
    try {
      _selectedProvider = await _repo.getById(id);
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<List<ProviderModel>> getByCategory(String category, {int? limit}) async {
    try {
      return await _repo.getByCategory(category, limit: limit);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  Future<void> loadFeaturedProviders() async {
    _featuredLoading = true;
    notifyListeners();
    try {
      _featuredProviders = await _repo.getFeaturedProviders();
      _featuredIds.clear();
      _featuredIds.addAll(_featuredProviders.map((p) => p.id));
    } catch (e) {
      _error = e.toString();
    }
    _featuredLoading = false;
    notifyListeners();
  }

  // ── Filtres ──

  void setCategory(String? category) {
    _categoryFilter = category;
    loadProviders();
  }

  void setVille(String? ville) {
    _villeFilter = ville;
    loadProviders();
  }

  void setSearch(String? query) {
    _searchQuery = (query != null && query.isEmpty) ? null : query;
    loadProviders();
  }

  void setSortBy(String field, {bool ascending = false}) {
    _sortBy = field;
    _sortAscending = ascending;
    loadProviders();
  }

  void clearFilters() {
    _categoryFilter = null;
    _villeFilter = null;
    _searchQuery = null;
    _sortBy = 'created_at';
    _sortAscending = false;
    loadProviders();
  }

  /// Vérifie si un prestataire est en vedette (abonné)
  bool isFeatured(String providerId) => _featuredIds.contains(providerId);

  // ── Helpers ──

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
