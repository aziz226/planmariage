import 'package:flutter/foundation.dart';

import '../core/models.dart';
import '../repositories/admin_repository.dart';

class AdminProvider extends ChangeNotifier {
  final AdminRepository _repo;

  AdminProvider(this._repo);

  // ── State ──
  Map<String, dynamic> _stats = {};
  List<BookingModel> _recentBookings = [];
  List<ProviderModel> _providers = [];
  List<BookingModel> _bookings = [];
  List<ReviewModel> _reviews = [];
  List<CategoryModel> _categories = [];
  List<UserModel> _users = [];
  List<ContactMessage> _messages = [];
  List<SubscriptionModel> _subscriptions = [];
  bool _loading = false;
  String? _error;

  // ── Getters ──
  Map<String, dynamic> get stats => _stats;
  List<BookingModel> get recentBookings => _recentBookings;
  List<ProviderModel> get providers => _providers;
  List<BookingModel> get bookings => _bookings;
  List<ReviewModel> get reviews => _reviews;
  List<CategoryModel> get categories => _categories;
  List<UserModel> get users => _users;
  List<ContactMessage> get messages => _messages;
  List<SubscriptionModel> get subscriptions => _subscriptions;
  bool get loading => _loading;
  String? get error => _error;

  // ── Dashboard ──

  Future<void> loadDashboard() async {
    _setLoading(true);
    try {
      _stats = await _repo.getStats();
      _recentBookings = await _repo.getRecentBookings();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  // ── Providers ──

  Future<void> loadProviders() async {
    _setLoading(true);
    try {
      _providers = await _repo.getAllProviders();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> createProvider(Map<String, dynamic> data) async {
    try {
      await _repo.createProvider(data);
      await loadProviders();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProvider(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateProvider(id, data);
      await loadProviders();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProvider(String id) async {
    try {
      await _repo.deleteProvider(id);
      _providers.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── Bookings ──

  Future<void> loadBookings() async {
    _setLoading(true);
    try {
      _bookings = await _repo.getAllBookings();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> updateBookingStatus(String id, String status) async {
    try {
      await _repo.updateBookingStatus(id, status);
      final idx = _bookings.indexWhere((b) => b.id == id);
      if (idx >= 0) {
        await loadBookings();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── Reviews ──

  Future<void> loadReviews() async {
    _setLoading(true);
    try {
      _reviews = await _repo.getAllReviews();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> deleteReview(String id) async {
    try {
      await _repo.deleteReview(id);
      _reviews.removeWhere((r) => r.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── Categories ──

  Future<void> loadCategories() async {
    _setLoading(true);
    try {
      _categories = await _repo.getAllCategories();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> createCategory(Map<String, dynamic> data) async {
    try {
      await _repo.createCategory(data);
      await loadCategories();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCategory(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateCategory(id, data);
      await loadCategories();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      await _repo.deleteCategory(id);
      _categories.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── Users ──

  Future<void> loadUsers() async {
    _setLoading(true);
    try {
      _users = await _repo.getAllUsers();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> updateUserRole(String id, String role) async {
    try {
      await _repo.updateUserRole(id, role);
      await loadUsers();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── Messages ──

  Future<void> loadMessages() async {
    _setLoading(true);
    try {
      _messages = await _repo.getAllMessages();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> deleteMessage(String id) async {
    try {
      await _repo.deleteMessage(id);
      _messages.removeWhere((m) => m.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── Subscriptions ──

  Future<void> loadSubscriptions() async {
    _setLoading(true);
    try {
      _subscriptions = await _repo.getAllSubscriptions();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  // ── Helpers ──

  void _setLoading(bool v) {
    _loading = v;
    _error = null;
    notifyListeners();
  }
}
