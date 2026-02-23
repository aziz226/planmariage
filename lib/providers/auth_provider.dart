import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

import '../core/models.dart';
import '../repositories/user_repository.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final UserRepository _userRepo;

  UserModel? _user;
  bool _loading = false;
  String? _error;
  StreamSubscription<AuthState>? _authSub;

  AuthProvider(this._authService, this._userRepo) {
    _init();
  }

  // ── Getters ──

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get loading => _loading;
  String? get error => _error;
  String? get uid => _authService.currentUser?.id;

  // ── Init ──

  void _init() {
    _authSub = _authService.authStateChanges.listen((state) {
      final event = state.event;
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.tokenRefreshed) {
        _loadProfile();
      } else if (event == AuthChangeEvent.signedOut) {
        _user = null;
        notifyListeners();
      }
    });
    // Charger le profil si déjà connecté
    if (_authService.currentUser != null) {
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    final uid = _authService.currentUser?.id;
    if (uid == null) return;
    try {
      _user = await _userRepo.getUser(uid);
      if (_user != null) {
        // Mettre à jour l'email depuis Supabase Auth
        _user = UserModel(
          id: _user!.id,
          email: _authService.currentUser?.email ?? '',
          displayName: _user!.displayName,
          phone: _user!.phone,
          photoUrl: _user!.photoUrl,
          ville: _user!.ville,
          createdAt: _user!.createdAt,
        );
      }
    } catch (_) {
      // Profil pas encore créé
    }
    notifyListeners();
  }

  // ── Actions ──

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _error = null;
    try {
      await _authService.signInWithEmail(email, password);
      await _loadProfile();
      _setLoading(false);
      return true;
    } catch (e) {
      _error = _parseError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
    String? phone,
    String? ville,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      await _authService.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
        phone: phone,
        ville: ville,
      );
      await _loadProfile();
      _setLoading(false);
      return true;
    } catch (e) {
      _error = _parseError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _error = null;
    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = _parseError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (uid == null) return;
    _setLoading(true);
    try {
      await _userRepo.updateUser(uid!, data);
      await _loadProfile();
    } catch (e) {
      _error = _parseError(e);
    }
    _setLoading(false);
  }

  // ── Helpers ──

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  String _parseError(dynamic e) {
    if (e is AuthException) return e.message;
    return e.toString();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
