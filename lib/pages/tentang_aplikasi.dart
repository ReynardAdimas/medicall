import 'package:flutter/material.dart';

class TentangAplikasi extends StatelessWidget {
  const TentangAplikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // Hapus shadow AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0), // Padding di sekitar konten utama
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Header dengan Logo dan Judul Aplikasi
            Center(
              child: Column(
                children: [
                  // Asumsi Anda memiliki logo Medicall.png di folder assets
                  // Jika tidak, Anda bisa menggantinya dengan ikon atau teks
                  Image.asset(
                    'assets/LogoMedicall.png', // Sesuaikan path logo Anda
                    height: 80, // Ukuran logo
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'MediCall',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700], // Warna hijau tema aplikasi
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Solusi Kesehatan Digital Anda',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // Spasi setelah header

            // Deskripsi Aplikasi Bagian 1
            _buildInfoSection(
              context,
              icon: Icons.info_outline,
              title: 'Apa itu MediCall?',
              description:
              'MediCall adalah aplikasi berbasis digital yang dibuat untuk memudahkan pasien dalam mendapatkan informasi layanan dan melakukan pendaftaran online di Klinik Bidan. Aplikasi ini menyajikan informasi lengkap seputar kehamilan, imunisasi, dan layanan kesehatan umum lainnya.',
              iconColor: Colors.blueAccent, // Warna ikon berbeda untuk menonjol
            ),
            const SizedBox(height: 20), // Spasi antar bagian

            // Deskripsi Aplikasi Bagian 2
            _buildInfoSection(
              context,
              icon: Icons.lightbulb_outline, // Ikon ide atau inovasi
              title: 'Manfaat Fitur Pendaftaran Online',
              description:
              'Dengan fitur pendaftaran online, MediCall membantu mengurangi antrean di klinik, mempercepat proses pelayanan, serta meningkatkan kenyamanan pasien.',
              iconColor: Colors.orangeAccent, // Warna ikon berbeda
            ),
            const SizedBox(height: 30), // Spasi di bagian bawah

            // Footer / Versi Aplikasi (Opsional)
            Center(
              child: Text(
                'Versi 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membangun setiap bagian informasi
  Widget _buildInfoSection(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    Color iconColor = Colors.grey, // Warna default jika tidak ditentukan
  }) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Pergeseran bayangan
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 30, color: iconColor), // Ikon dengan warna kustom
              const SizedBox(width: 10),
              Expanded( // Menggunakan Expanded agar teks judul tidak overflow
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 0.5, color: Colors.grey), // Garis pemisah
          Text(
            description,
            textAlign: TextAlign.justify, // Teks rata kanan kiri
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5, // Jarak antar baris untuk keterbacaan
            ),
          ),
        ],
      ),
    );
  }
}
