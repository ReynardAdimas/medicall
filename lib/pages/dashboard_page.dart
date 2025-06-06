import 'package:flutter/material.dart';
import 'package:supaaaa/auth/auth_services.dart';
import 'package:supaaaa/pendaftaranPasien/pages/pendaftaran_pages.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  // get auth service
  final authService = AuthService();
  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Page"),
        actions: [
          // logout button
          IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout)
          )
        ],
      ),
      body:
      ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PendaftaranPages()));
          },
          child: const Text("Pendaftaran")
      )
    );
  }
}
