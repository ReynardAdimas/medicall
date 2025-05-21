import 'package:flutter/material.dart';
import 'package:supaaaa/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
      url: "https://yrunudgtxrzssgtqfaif.supabase.co",
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlydW51ZGd0eHJ6c3NndHFmYWlmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc4MjI1OTgsImV4cCI6MjA2MzM5ODU5OH0.0AG2rI38SuwtjW8TaFDH6Q-AKDCVPfMwEBIB33tCy1E'
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
