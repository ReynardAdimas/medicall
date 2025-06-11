import 'package:flutter/material.dart';
import 'package:supaaaa/pages/dashboard_page.dart'; // Asumsikan ini adalah BerandaPasienScreen
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage1 extends StatefulWidget {
  const RegisterPage1({super.key});

  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  final _formKey = GlobalKey<FormState>(); // Kunci global untuk form

  final namaController = TextEditingController();
  final genderController = TextEditingController();
  final umurController = TextEditingController();
  final pekerjaanController = TextEditingController();
  final alamatController = TextEditingController();
  final nomerHpController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    genderController.dispose();
    umurController.dispose();
    pekerjaanController.dispose();
    alamatController.dispose();
    nomerHpController.dispose();
    super.dispose();
  }

  // Fungsi validasi untuk nomor handphone Indonesia
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor handphone tidak boleh kosong';
    }

    // Hapus spasi atau karakter non-digit lainnya (kecuali + di awal)
    String cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Cek apakah dimulai dengan '08' atau '+628'
    if (!cleanedValue.startsWith('08') && !cleanedValue.startsWith('+628')) {
      return 'Format nomor handphone tidak valid (harus dimulai dengan 08 atau +628)';
    }

    // Jika dimulai dengan '+62', pastikan panjangnya valid setelah +62
    if (cleanedValue.startsWith('+62')) {
      if (cleanedValue.length < 10 || cleanedValue.length > 15) { // +62 + (7-12 digit) = 9-14
        return 'Panjang nomor handphone tidak valid (minimal 10, maksimal 15 digit termasuk +62)';
      }
    } else if (cleanedValue.startsWith('08')) {
      // Jika dimulai dengan '08', pastikan panjangnya valid setelah 08
      if (cleanedValue.length < 9 || cleanedValue.length > 14) { // 08 + (7-12 digit) = 9-14
        return 'Panjang nomor handphone tidak valid (minimal 9, maksimal 14 digit)';
      }
    }

    // Pastikan hanya terdiri dari digit setelah prefix
    if (!RegExp(r'^\+?\d+$').hasMatch(cleanedValue)) {
      return 'Nomor handphone hanya boleh mengandung angka';
    }

    return null;
  }


  Future<void> submitData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nama = namaController.text;
    final gender = genderController.text;
    final umur = int.tryParse(umurController.text) ?? 0;
    final pekerjaan = pekerjaanController.text;
    final alamat = alamatController.text;
    final nomerHp = nomerHpController.text; // Nomor HP sudah divalidasi formatnya

    final supabase = Supabase.instance.client;

    try {
      // cek apakah data redunan
      final user = supabase.auth.currentUser;
      final idPasien = user?.id;

      // Hapus karakter non-digit dari nomor HP sebelum mengecek redundansi
      // dan sebelum menyimpan ke database agar konsisten
      String cleanedNomerHp = nomerHp.replaceAll(RegExp(r'[^\d]'), '');
      if (cleanedNomerHp.startsWith('0')) {
        cleanedNomerHp = '62' + cleanedNomerHp.substring(1); // Ubah 08 menjadi 628
      } else if (!cleanedNomerHp.startsWith('62')) {
        cleanedNomerHp = '62' + cleanedNomerHp;
      }


      final existing = await supabase.from('pasien').select().eq('nomerhp', cleanedNomerHp).maybeSingle();
      if (existing != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nomor HP Sudah Terdaftar'))
        );
        return;
      }

      await supabase.from('pasien').insert({
        'nama': nama,
        'gender': gender,
        'umur': umur,
        'pekerjaan': pekerjaan,
        'alamat': alamat,
        'nomerhp': cleanedNomerHp, // Simpan nomor yang sudah diformat
        'user_id': idPasien,
      });

      // Pastikan Navigator.pop hanya dipanggil jika ada rute sebelumnya
      // Atau langsung push replacement jika ini adalah alur pendaftaran utama
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BerandaPasienScreen()));


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')) // Tampilkan pesan error yang lebih jelas
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lengkapi data diri kamu"),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form( // Bungkus Column dengan Form
            key: _formKey, // Berikan kunci form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Icon kembali & Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Image.asset(
                      'assets/LogoMedicall.png', // Pastikan path ini benar dan aset sudah ditambahkan
                      height: 60,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Nama
                const Text('Nama'),
                const SizedBox(height: 8),
                _buildTextFormField('ketik disini', namaController,
                    validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null),

                const SizedBox(height: 16),

                // Gender
                const Text('Gender'),
                const SizedBox(height: 8),
                _buildTextFormField('laki-laki/perempuan', genderController,
                    validator: (value) => value!.isEmpty ? 'Gender tidak boleh kosong' : null),

                const SizedBox(height: 16),

                // Umur
                const Text('Umur'),
                const SizedBox(height: 8),
                _buildTextFormField('ketik disini', umurController, keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) return 'Umur tidak boleh kosong';
                      if (int.tryParse(value) == null) return 'Umur harus angka';
                      if (int.parse(value) <= 0) return 'Umur tidak valid';
                      return null;
                    }),

                const SizedBox(height: 16),

                // Pekerjaan
                const Text('Pekerjaan'),
                const SizedBox(height: 8),
                _buildTextFormField('ketik disini', pekerjaanController,
                    validator: (value) => value!.isEmpty ? 'Pekerjaan tidak boleh kosong' : null),

                const SizedBox(height: 16),

                // Alamat
                const Text('Alamat'),
                const SizedBox(height: 8),
                _buildTextFormField('ketik disini', alamatController,
                    validator: (value) => value!.isEmpty ? 'Alamat tidak boleh kosong' : null),

                const SizedBox(height: 16),

                // Nomor HP (Sekarang TextFormField dengan validator)
                const Text('Nomer HP'),
                const SizedBox(height: 8),
                _buildTextFormField('contoh: 081234567890 atau +6281234567890', nomerHpController,
                    keyboardType: TextInputType.phone,
                    validator: _validatePhoneNumber), // Menggunakan validator yang baru dibuat

                const SizedBox(height: 32),

                // Tombol Lanjut
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF95E06C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: submitData,
                    child: const Text(
                      'Lanjut',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Mengganti _buildTextField menjadi _buildTextFormField
  Widget _buildTextFormField(String hint, TextEditingController ct, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField( // Menggunakan TextFormField
      controller: ct,
      keyboardType: keyboardType,
      validator: validator, // Menambahkan validator
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder( // Menambahkan focusedBorder untuk estetika
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF95E06C), width: 2),
        ),
        errorBorder: OutlineInputBorder( // Menambahkan errorBorder
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder( // Menambahkan focusedErrorBorder
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}