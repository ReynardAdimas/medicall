import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'pengaturanPage.dart';
import 'dashboard_page.dart';

class ProfilSayaScreen extends StatefulWidget { // Ubah menjadi StatefulWidget
  const ProfilSayaScreen({super.key});

  @override
  State<ProfilSayaScreen> createState() => _ProfilSayaScreenState();
}

class _ProfilSayaScreenState extends State<ProfilSayaScreen> {
  File? _image;
  int _selectedIndex = 1; // Indeks untuk Profil

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
      // Sudah di Profil, tidak perlu navigasi
    } else if (index == 2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PengaturanScreen()),
            (route) => false,
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              color: Colors.green[700],
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 40),
                          const Text(
                            'Andhika Kusuma Wardana',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text('Tinggi',
                                      style: TextStyle(color: Colors.grey)),
                                  const Text('-', style: TextStyle(fontSize: 16)),
                                  const Text('Cm',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(width: 30),
                              Column(
                                children: [
                                  const Text('Berat',
                                      style: TextStyle(color: Colors.grey)),
                                  const Text('-', style: TextStyle(fontSize: 16)),
                                  const Text('Kg',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(width: 30),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text('BMI',
                                          style: TextStyle(color: Colors.grey)),
                                      const Icon(Icons.info_outline,
                                          size: 14, color: Colors.grey),
                                    ],
                                  ),
                                  const Text('-', style: TextStyle(fontSize: 16)),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _image != null ? FileImage(_image!) : null,
                              child: _image == null
                                  ? Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey[600],
                              )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey[300]!, width: 1),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      right: 40,
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.green[700]),
                        onPressed: () {
                          // Handle edit profile tap
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileDetail(
              label: 'Nomer Ponsel',
              value: '+6288923892877',
              onTap: () {
                // Handle change phone number
              },
            ),
            _buildProfileDetail(
              label: 'Kata Sandi',
              value: '*********',
              onTap: () {
                // Handle change password
              },
            ),
            _buildProfileDetail(
              label: 'Jadwal Kamu',
              value: 'Cek',
              isLink: true,
              onTap: () {
                // Handle view schedule
              },
            ),
            _buildProfileDetail(
              label: 'Diagnosis',
              value: 'Cek',
              isLink: true,
              onTap: () {
                // Handle view diagnosis
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildProfileDetail({
    required String label,
    required String value,
    bool isLink = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              if (onTap != null)
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    isLink ? 'Cek' : 'Ubah',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const Divider(color: Colors.grey, thickness: 0.5),
        ],
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