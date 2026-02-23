import 'package:flutter/foundation.dart';

import '../core/models.dart';
import '../repositories/pack_repository.dart';

class PackProvider extends ChangeNotifier {
  final PackRepository _repo;

  PackProvider(this._repo);

  List<PackModel> _packs = [];
  List<PackModel> _allPacks = [];
  bool _loading = false;
  String? _error;

  List<PackModel> get packs => _packs;
  List<PackModel> get allPacks => _allPacks;
  bool get loading => _loading;
  String? get error => _error;

  /// Load all packs (for home page)
  Future<void> loadAllPacks({int? limit}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _allPacks = await _repo.getAllPacks(limit: limit);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  /// Load packs for a specific provider
  Future<void> loadProviderPacks(String providerId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _packs = await _repo.getProviderPacks(providerId);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  void clear() {
    _packs = [];
    _error = null;
    notifyListeners();
  }
}
