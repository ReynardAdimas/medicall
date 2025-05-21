import 'package:flutter/material.dart';
import 'package:supaaaa/auth/auth_services.dart';


class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {

  // get auth service
  final authService = AuthService();
  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          // logout button
          IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout)
          )
        ],
      ),
      body:
      Center(
        child: Text("Dashboard Admin"),
      ),
    );
  }
}
