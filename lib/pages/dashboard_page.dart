import 'package:flutter/material.dart';
import 'package:supaaaa/pages/pengaturanPage.dart';
import 'package:supaaaa/pages/profilePage.dart';
import 'package:supaaaa/pendaftaranPasien/pages/pendaftaran_pages.dart';

class BerandaPasienScreen extends StatefulWidget { // Ubah menjadi StatefulWidget
  const BerandaPasienScreen({super.key});

  @override
  State<BerandaPasienScreen> createState() => _BerandaPasienScreenState();
}

class _BerandaPasienScreenState extends State<BerandaPasienScreen> {
  int _selectedIndex = 0; // Indeks untuk Beranda

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigasi berdasarkan index
    if (index == 0) {
      // Sudah di Beranda, tidak perlu navigasi
    } else if (index == 1) {
      Navigator.pushAndRemoveUntil( // Gunakan pushAndRemoveUntil agar tidak menumpuk halaman
        context,
        MaterialPageRoute(builder: (context) => const ProfilSayaScreen()),
            (route) => false, // Hapus semua route sebelumnya
      );
    } else if (index == 2) {
      Navigator.pushAndRemoveUntil( // Gunakan pushAndRemoveUntil agar tidak menumpuk halaman
        context,
        MaterialPageRoute(builder: (context) => const PengaturanScreen()),
            (route) => false, // Hapus semua route sebelumnya
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Hi, andhika',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _ServiceItem(
                    icon: Icons.person_add_alt_1,
                    label: 'Pendaftaran',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PendaftaranPages()));
                    },
                  ),
                  _ServiceItem(
                    icon: Icons.monitor_weight,
                    label: 'Hitung BMI',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Hitung BMI tapped!')),
                      );
                    },
                  ),
                  _ServiceItem(
                    icon: Icons.vaccines,
                    label: 'Imunisasi',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Imunisasi tapped!')),
                      );
                    },
                  ),
                  _ServiceItem(
                    icon: Icons.calendar_month,
                    label: 'Kalender Kehamilan',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kalender Kehamilan tapped!')),
                      );
                    },
                  ),
                  _ServiceItem(
                    icon: Icons.crisis_alert,
                    label: 'Layanan Darurat',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Layanan Darurat tapped!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Berita',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return const _NewsCard();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
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
          color: isSelected ? Colors.white : Colors.transparent, // Warna latar belakang sesuai seleksi
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
              : null, // Tidak ada shadow jika tidak terpilih
        ),
        child: Center(
          child: Icon(
            icon,
            color: isSelected ? Colors.green[700] : Colors.white, // Warna ikon sesuai seleksi
            size: 30,
          ),
        ),
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ServiceItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green[100],
            child: Icon(icon, color: Colors.green[700], size: 30),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kesehatan Mental',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Renungan Tahun Baru dan Pentingnya Resolusi \'Lebih Sehat\'',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '30 Dec 2024',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/80'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}