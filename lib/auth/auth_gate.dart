// // unauthenticated --> Login Page
// // authenticated --> Dashboard Page

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supaaaa/pages/dashboard_admin.dart';
import 'package:supaaaa/pages/register_page_1.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/dashboard_page.dart';
import '../pages/login_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _checking = true;
  Widget? _nextPage; 
  late final StreamSubscription<AuthState> _authSub;

  @override
  void initState() {
    super.initState();
    _checkAuthAndRedirect(); 
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      _checkAuthAndRedirect();
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  Future<void> _checkAuthAndRedirect() async {
    final session = Supabase.instance.client.auth.currentSession;
    final user = session?.user;

    if (user == null) {
      // Belum login
      setState(() {
        _nextPage = const LoginPage();
        _checking = false;
      });
      return;
    }

    if (user.email == 'admin@gmail.com') {
      setState(() {
        _nextPage = const DashboardAdmin();
        _checking = false;
      });
      return;
    }

    // Cek data pasien berdasarkan user_id
    final response = await Supabase.instance.client
        .from('pasien')
        .select('nomerhp')
        .eq('user_id', user.id)
        .maybeSingle();

    final nomerhp = response?['nomerhp'];

    setState(() {
      if (nomerhp == null || nomerhp.toString().isEmpty) {
        _nextPage = const RegisterPage1();
      } else {
        _nextPage = const DashboardPage();
      }
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return _nextPage!;
  }
}
