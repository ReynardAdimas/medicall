import 'package:flutter/material.dart';
import 'package:supaaaa/auth/auth_services.dart';
import 'package:supaaaa/daftarPasien/pages/daftarPasien.dart';
import 'package:supaaaa/jadwalKunjungan/pages/jadwalKunjungan.dart';
import 'package:supaaaa/obat/pages/obat_1.dart';
import 'package:supaaaa/riwayatKunjungan/pages/riwayatKunjungan1.dart';


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
      backgroundColor: Colors.white, // Latar belakang putih sesuai desain
      body: SingleChildScrollView( // Agar bisa di-scroll jika konten melebihi layar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Header "Hi, Admin"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40, left: 24, right: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFd4f6c4), // Warna hijau muda atas
                    Colors.white,      // Warna putih bawah
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(36), // Rounded bottom corners
                ),
              ),
              child: const Text(
                'Hi, Admin',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 32), // Spasi setelah header

            // Kartu-kartu Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Kartu Inventaris Obat
                  _buildMenuItem(
                    context,
                    'Inventaris Obat',
                    'assets/inventaris-icon.png', // Ganti dengan path gambar Anda
                        () {
                      // Aksi saat kartu diklik
                      print('Inventaris Obat clicked');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Obat1()));
                    },
                  ),
                  const SizedBox(height: 16), // Spasi antar kartu

                  // Kartu Jadwal Kunjungan
                  _buildMenuItem(
                    context,
                    'Jadwal Kunjungan',
                    'assets/jadwal-icon.png', // Ganti dengan path gambar Anda
                        () {
                      // Aksi saat kartu diklik
                      print('Jadwal Kunjungan clicked');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Jadwalkunjungan()));
                    },
                  ),
                  const SizedBox(height: 16),

                  // Kartu Daftar Kunjungan Pasien
                  _buildMenuItem(
                    context,
                    'Daftar Kunjungan Pasien',
                    'assets/daftar-pasien-icon.png', // Ganti dengan path gambar Anda
                        () {
                      // Aksi saat kartu diklik
                      print('Daftar Kunjungan Pasien clicked');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Riwayatkunjungan1()));
                    },
                  ),
                  const SizedBox(height: 16),

                  // Kartu Daftar Pasien
                  _buildMenuItem(
                    context,
                    'Daftar Pasien',
                    'assets/daftar-pasien-icon.png', // Ganti dengan path gambar Anda
                        () {
                      // Aksi saat kartu diklik
                      print('Daftar Pasien clicked');

                      Navigator.push(context, MaterialPageRoute(builder: (context) => Daftarpasien()));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60), // Spasi sebelum tombol keluar

            // Tombol Keluar (Bottom Right)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0, bottom: 24.0),
                child: FloatingActionButton.extended(
                  onPressed: logout,
                  label: const Text(
                    'Keluar',
                    style: TextStyle(color: Colors.white), // Warna teks putih
                  ),
                  icon: const Icon(Icons.logout, color: Colors.white), // Icon logout putih
                  backgroundColor: const Color(0xFFd4f6c4), // Warna tombol keluar
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24), // Rounded corners
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Spasi di bagian paling bawah
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk membuat item menu kartu
  Widget _buildMenuItem(BuildContext context, String title, String iconPath, VoidCallback onTap) {
    return Card(
      elevation: 4, // Shadow untuk kartu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners untuk kartu
      ),
      child: InkWell( // Membuat kartu bisa diklik
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Image.asset(
                iconPath,
                width: 48, // Ukuran ikon/gambar
                height: 48,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback jika gambar tidak ditemukan
                  return const Icon(Icons.image_not_supported, size: 48, color: Colors.grey);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Dashboard Admin"),
  //       actions: [
  //         // logout button
  //         IconButton(
  //             onPressed: logout,
  //             icon: const Icon(Icons.logout)
  //         )
  //       ],
  //     ),
  //     body: Column(
  //       children: [
  //         ElevatedButton(
  //             onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Obat1())),
  //             child: Text("Inventasris Obat")
  //         ),ElevatedButton(
  //             onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Jadwalkunjungan())),
  //             child: Text("Jadwal Kunjungan")
  //         ),ElevatedButton(
  //             onPressed: () { },
  //             child: Text("Daftar Kunjungan Pasien")
  //         ),ElevatedButton(
  //             onPressed: () { },
  //             child: Text("Daftar Pasien")
  //         ),
  //       ]
  //     )
  //   );
  //
  // }
}
