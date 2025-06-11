import 'package:flutter/material.dart';
import 'package:supaaaa/auth/auth_services.dart';
import 'package:supaaaa/pages/login_page.dart';
import 'package:supaaaa/pages/profilePage.dart';
import 'package:supaaaa/pages/tentang_aplikasi.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'dashboard_page.dart'; // Asumsikan ini adalah BerandaPasienScreen

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  int _selectedIndex = 2;

  final AuthService _authService = AuthService(); // Gunakan _authService yang sudah ada
  final SupabaseClient _supabase = Supabase.instance.client; // Dapatkan instance Supabase client

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BerandaPasienScreen()),
            (route) => false,
      );
    } else if (index == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ProfilSayaScreen()),
            (route) => false,
      );
    } else if (index == 2) {
      // Sudah di Pengaturan, tidak perlu navigasi
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi logout
  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Keluar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus akun pengguna telah dihapus karena alasan keamanan dan rekomendasi.
  // Jika diperlukan di masa mendatang, implementasikan ini di sisi server (Supabase Edge Function)
  // untuk keamanan Service Role Key.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildSettingsItem(
            icon: Icons.info_outline,
            label: 'Tentang Aplikasi',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TentangAplikasi()));
            },
          ),
          _buildSettingsItem(
            icon: Icons.logout,
            label: 'Keluar',
            onTap: () async {
              bool? confirmLogout = await _showLogoutConfirmationDialog(context);
              if(confirmLogout == true) {
                await _authService.signOut(); // Menggunakan _authService
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anda telah keluar'))
                );
                // Navigasi ke halaman login setelah logout
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              }
            },
          ),
          // Fitur "Hapus Akun" telah dihapus dari sini.
          // _buildSettingsItem(
          //   icon: Icons.delete_outline,
          //   label: 'Hapus Akun',
          //   onTap: () {
          //     _showDeleteAccountConfirmationDialog(context);
          //   },
          //   isDestructive: true,
          // ),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive ? Colors.red : Colors.green[700],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDestructive ? Colors.red : Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[600],
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(
            icon: Icons.home,
            index: 0,
            onTap: _onItemTapped,
            isSelected: _selectedIndex == 0,
          ),
          _buildNavBarItem(
            icon: Icons.person,
            index: 1,
            onTap: _onItemTapped,
            isSelected: _selectedIndex == 1,
          ),
          _buildNavBarItem(
            icon: Icons.settings,
            index: 2,
            onTap: _onItemTapped,
            isSelected: _selectedIndex == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem({
    required IconData icon,
    required int index,
    required ValueChanged<int> onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ]
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            color: isSelected ? Colors.green[700] : Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
