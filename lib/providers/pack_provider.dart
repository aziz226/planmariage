import 'package:flutter/foundation.dart';

import '../core/models.dart';
import '../repositories/pack_repository.dart';

class PackProvider extends ChangeNotifier {
  final PackRepository _repo;

  PackProvider(this._repo);

  List<PackModel> _packs = [];
  bool _loading = false;
  String? _error;

  List<PackModel> get packs => _packs;
  bool get loading => _loading;
  String? get error => _error;

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
