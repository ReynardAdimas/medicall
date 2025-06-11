import 'package:flutter/material.dart';
import 'package:supaaaa/auth/auth_gate.dart'; // Import AuthGate Anda

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Setelah beberapa detik (misalnya 3 detik), navigasi ke AuthGate
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthGate()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih seperti gambar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten secara vertikal
          children: [

            Image.asset(
              'assets/LogoMedicall.png', // <-- GANTI DENGAN PATH IKON HATI ANDA
              height: 100, // Sesuaikan ukuran sesuai kebutuhan
              width: 100,
              errorBuilder: (context, error, stackTrace) {
                // Fallback jika gambar tidak ditemukan atau gagal dimuat
                return Icon(
                  Icons.favorite, // Ikon hati generik sebagai alternatif
                  size: 100,
                  color: Colors.lightGreen, // Sesuaikan warna dengan tema MediCall
                );
              },
            ),
            const SizedBox(height: 16), // Spasi antara ikon dan teks

            // Teks "MediCall"
            const Text(
              'MediCall',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.lightGreen, // Sesuaikan warna dengan tema MediCall
              ),
            ),
          ],
        ),
      ),
    );
  }
}