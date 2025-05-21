import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // sign in email and password
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password
    );
  }
  // sign up with email and password
  Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
      return await _supabaseClient.auth.signUp(
          email: email,
          password: password
      );
  }
  // sign out
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }
  // get user email
  String? getCurrentUserEmail() {
    final session = _supabaseClient.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  // reset password
  Future<void> sendResetPasswordEmail(String email) async {
    await _supabaseClient.auth.resetPasswordForEmail(email);
  }
}