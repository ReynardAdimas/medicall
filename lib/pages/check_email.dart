import 'package:flutter/material.dart';

class CheckEmailPage extends StatelessWidget {
  const CheckEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih sesuai gambar
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Ikon panah kembali
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        backgroundColor: Colors.white, // Warna AppBar putih
        elevation: 0, // Tanpa bayangan di bawah AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten secara vertikal
          children: [
            // Spacer untuk mendorong konten sedikit ke atas dari posisi tengah absolut
            const Spacer(),

            // Ikon Email
            // Anda perlu menambahkan aset gambar ini ke folder 'assets/' dan mendaftarkannya di pubspec.yaml
            Image.asset(
              'assets/Email.png', // Ganti dengan path aset ikon email Anda
              height: 120, // Sesuaikan ukuran sesuai kebutuhan
              width: 120,
              errorBuilder: (context, error, stackTrace) {
                // Fallback jika gambar aset tidak ditemukan
                return Icon(
                  Icons.email,
                  size: 120,
                  color: Colors.grey[400],
                );
              },
            ),
            const SizedBox(height: 32), // Spasi antara ikon dan teks

            // Teks "Cek Email Anda!!!"
            const Text(
              'Cek Email Anda!!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const Spacer(), // Spacer untuk mendorong tombol ke bagian bawah

            // Tombol "Kembali"
            SizedBox(
              width: double.infinity, // Lebar penuh
              height: 50, // Tinggi tombol
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF95E06C), // Warna hijau untuk tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24), // Sudut membulat
                  ),
                  elevation: 4, // Efek bayangan
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Warna teks putih
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24), // Padding di bagian paling bawah
          ],
        ),
      ),
    );
  }
}