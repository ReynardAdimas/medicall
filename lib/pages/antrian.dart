import 'package:flutter/material.dart';

class RegistrationSuccessPage extends StatelessWidget {
  const RegistrationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      appBar: AppBar(
        title: const Text(
          'Pendaftaran',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            // Menggunakan font Montserrat jika sudah didefinisikan atau font default sistem
            // fontFamily: 'Montserrat', // Uncomment jika Anda menggunakan font kustom
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true, // Pusatkan judul
        backgroundColor: Colors.white, // Warna AppBar putih
        elevation: 0, // Tanpa bayangan di bawah AppBar
        automaticallyImplyLeading: false, // Hapus tombol kembali default jika tidak diperlukan
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Mendistribusikan ruang secara merata
          children: [
            // Spacer untuk memberi sedikit ruang di bagian atas
            const Spacer(flex: 2),

            // Gambar antrian anak-anak
            // Anda perlu menambahkan aset gambar ini ke folder 'assets/' dan mendaftarkannya di pubspec.yaml
            Image.asset(
              'assets/antrian.png', // Ganti dengan path aset gambar antrian Anda
              height: 200, // Sesuaikan tinggi gambar
              fit: BoxFit.contain, // Sesuaikan dengan kebutuhan layout
              errorBuilder: (context, error, stackTrace) {
                // Fallback jika gambar aset tidak ditemukan
                return Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.people_alt, // Ikon pengganti jika gambar tidak ada
                    size: 150,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            const SizedBox(height: 40), // Spasi setelah gambar

            // Pesan terima kasih
            const Text(
              'Terima kasih,\nPasien yang dilayani sesuai urutan kedatangan pada saat di klinik',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5, // Jarak antar baris untuk keterbacaan
                color: Colors.black87,
              ),
            ),

            // Spacer untuk mendorong tombol "Kembali" ke bagian paling bawah
            const Spacer(flex: 3),

            // Tombol "Kembali"
            SizedBox(
              width: double.infinity, // Lebar penuh
              height: 50, // Tinggi tombol
              child: ElevatedButton(
                onPressed: () {
                  // Fungsi untuk kembali ke halaman utama (misalnya dashboard pasien)
                  // Menggunakan popUntil untuk memastikan semua rute di atasnya dihapus
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BC34A), // Warna hijau untuk tombol
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