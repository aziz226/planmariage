import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
    String? phone,
    String? ville,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'display_name': displayName,
        'phone': phone,
        'ville': ville,
      },
    );
    // Créer le profil dans la table profiles
    if (response.user != null) {
      await _client.from('profiles').upsert({
        'id': response.user!.id,
        'display_name': displayName,
        'phone': phone,
        'ville': ville,
      });
    }
    return response;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }
}
