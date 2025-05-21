// unauthenticated --> Login Page
// authenticated --> Dashboard Page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supaaaa/pages/dashboard_admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/dashboard_page.dart';
import '../pages/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        // listen to auth statechange
        stream: Supabase.instance.client.auth.onAuthStateChange,

        // build appropriate page based on auth state
        builder: (context, snapshot) {
          // loading
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body:Center(child: CircularProgressIndicator(),)
            );
          }
          // check if there is a valid session currently
          final session = snapshot.hasData ? snapshot.data!.session : null;

          if(session != null && session.user.email=="admin@gmail.com") {
              return const DashboardAdmin();
          } else if(session != null) {
            return const DashboardPage();
          } else {
            return const LoginPage();
          }
        }
    );
  }
}
