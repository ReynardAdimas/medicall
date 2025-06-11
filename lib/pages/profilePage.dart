import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supaaaa/pages/cek_jadwal.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cek_diagnosis.dart';
import 'pengaturanPage.dart';
import 'dashboard_page.dart';
import 'edit_phone_number_screen.dart'; // Import halaman baru

class ProfilSayaScreen extends StatefulWidget {
  const ProfilSayaScreen({super.key});

  @override
  State<ProfilSayaScreen> createState() => _ProfilSayaScreenState();
}

class _ProfilSayaScreenState extends State<ProfilSayaScreen> {
  File? _image;
  int _selectedIndex = 1;

  String? _namaPasien;
  String? _nomerHp;
  int? _umur;
  String? _gender;
  String? _pekerjaan;
  String? _alamat;
  String? _userUuid;

  final TextEditingController _tinggiBadanController = TextEditingController();
  final TextEditingController _beratBadanController = TextEditingController();

  String _bmiResult = '-';
  bool _isEditingBodyData = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _loadLocalBodyData();
  }

  @override
  void dispose() {
    _tinggiBadanController.dispose();
    _beratBadanController.dispose();
    super.dispose();
  }

  Future<void> _loadLocalBodyData() async {
    final prefs = await SharedPreferences.getInstance();
    final double? savedTinggi = prefs.getDouble('tinggiBadan');
    final double? savedBerat = prefs.getDouble('beratBadan');

    if (savedTinggi != null) {
      _tinggiBadanController.text = savedTinggi.toStringAsFixed(0);
    }
    if (savedBerat != null) {
      _beratBadanController.text = savedBerat.toStringAsFixed(0);
    }
    _calculateBMI();
  }

  Future<void> _saveLocalBodyData() async {
    final prefs = await SharedPreferences.getInstance();
    final double? tinggi = double.tryParse(_tinggiBadanController.text);
    final double? berat = double.tryParse(_beratBadanController.text);

    if (tinggi != null) {
      await prefs.setDouble('tinggiBadan', tinggi);
    } else {
      await prefs.remove('tinggiBadan');
    }
    if (berat != null) {
      await prefs.setDouble('beratBadan', berat);
    } else {
      await prefs.remove('beratBadan');
    }
    _calculateBMI();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tinggi dan Berat Badan tersimpan.')),
    );
  }

  void _calculateBMI() {
    final double? tinggi = double.tryParse(_tinggiBadanController.text);
    final double? berat = double.tryParse(_beratBadanController.text);

    if (tinggi != null && berat != null && tinggi > 0) {
      final double tinggiMeter = tinggi / 100;
      final double bmiValue = berat / (tinggiMeter * tinggiMeter);
      setState(() {
        _bmiResult = bmiValue.toStringAsFixed(2);
      });
    } else {
      setState(() {
        _bmiResult = '-';
      });
    }
  }

  Future<void> _fetchUserData() async {
    final supabase = Supabase.instance.client;
    final User? currentUser = supabase.auth.currentUser;

    if (currentUser == null) {
      print('Tidak ada pengguna yang login.');
      return;
    }

    setState(() {
      _userUuid = currentUser.id;
    });

    try {
      final response = await supabase
          .from('pasien')
          .select('nama, nomerhp, umur, gender, pekerjaan, alamat')
          .eq('user_id', currentUser.id)
          .single();

      setState(() {
        _namaPasien = response['nama'] as String?;
        _nomerHp = response['nomerhp'] as String?;
        _umur = response['umur'] as int?;
        _gender = response['gender'] as String?;
        _pekerjaan = response['pekerjaan'] as String?;
        _alamat = response['alamat'] as String?;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data profil: ${e.toString()}')),
      );
    }
  }

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
      // Di sini Anda bisa menambahkan logika untuk mengupload gambar ke Supabase Storage
      // dan menyimpan URL-nya di tabel pasien.
    }
  }

  void _toggleEditBodyData() {
    setState(() {
      _isEditingBodyData = !_isEditingBodyData;
    });
    if (!_isEditingBodyData) {
      _saveLocalBodyData();
    }
  }

  Future<void> _navigateToEditPhoneNumber() async {
    if (_nomerHp == null || _userUuid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data nomor ponsel atau ID pengguna belum tersedia.')),
      );
      return;
    }

    final bool? isUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPhoneNumberScreen(
          currentPhoneNumber: _nomerHp!,
          userUuid: _userUuid!,
        ),
      ),
    );

    if (isUpdated == true) {
      _fetchUserData();
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
              height: 250,
              color: Colors.green[700],
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 60,
                    left: 16,
                    right: 16,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                          const SizedBox(height: 50),
                          Text(
                            _namaPasien ?? 'Memuat Nama...',
                            style: const TextStyle(
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
                                  SizedBox(
                                    width: 60,
                                    child: TextField(
                                      controller: _tinggiBadanController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      readOnly: !_isEditingBodyData,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        hintText: '-',
                                        enabledBorder: _isEditingBodyData ? const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey),
                                        ) : InputBorder.none,
                                        focusedBorder: _isEditingBodyData ? const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.green),
                                        ) : InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        _calculateBMI();
                                      },
                                    ),
                                  ),
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
                                  SizedBox(
                                    width: 60,
                                    child: TextField(
                                      controller: _beratBadanController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      readOnly: !_isEditingBodyData,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        hintText: '-',
                                        enabledBorder: _isEditingBodyData ? const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey),
                                        ) : InputBorder.none,
                                        focusedBorder: _isEditingBodyData ? const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.green),
                                        ) : InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        _calculateBMI();
                                      },
                                    ),
                                  ),
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
                                  Text(_bmiResult, style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
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
                    top: 180,
                    right: 40,
                    child: IconButton(
                      icon: Icon(
                        _isEditingBodyData ? Icons.save : Icons.edit,
                        color: Colors.green[700],
                      ),
                      onPressed: _toggleEditBodyData,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildProfileDetail(
              label: 'Nomer Ponsel',
              value: _nomerHp ?? 'Memuat...',
              onTap: _navigateToEditPhoneNumber, // Panggil fungsi navigasi
            ),
            _buildProfileDetail(
              label: 'Kata Sandi',
              value: '*********',
              onTap: () {
                // Handle change password
              },
            ),
            _buildProfileDetail(
              label: 'Umur',
              value: (_umur != null) ? '$_umur tahun' : 'Memuat...',
              onTap: null,
            ),
            _buildProfileDetail(
              label: 'Gender',
              value: _gender ?? 'Memuat...',
              onTap: null,
            ),
            _buildProfileDetail(
              label: 'Pekerjaan',
              value: _pekerjaan ?? 'Memuat...',
              onTap: null,
            ),
            _buildProfileDetail(
              label: 'Alamat',
              value: _alamat ?? 'Memuat...',
              onTap: null,
            ),
            _buildProfileDetail(
              label: 'Jadwal Kamu',
              value: 'Cek',
              isLink: true,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CekJadwalScreen()));
              },
            ),
            _buildProfileDetail(
              label: 'Diagnosis',
              value: 'Cek',
              isLink: true,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CekDiagnosis()));
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
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
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

  // Fixing the error in _buildNavBarItem
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