import 'package:flutter/material.dart';
import 'package:supaaaa/pages/dashboard_page.dart';
import 'package:supaaaa/pages/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage1 extends StatefulWidget {
  const RegisterPage1({super.key});

  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {

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
  } 
  
  Future<void> submitData() async {
    final nama = namaController.text;
    final gender = genderController.text;
    final umur = int.tryParse(umurController.text) ?? 0;
    final pekerjaan = pekerjaanController.text;
    final alamat = alamatController.text;
    final nomerHp = nomerHpController.text;

    final supabase = Supabase.instance.client;


    try{
      // cek apakah data redunan
      final user = supabase.auth.currentUser;
      final idPasien = user?.id;
      final existing = await supabase.from('pasien').select().eq('nomerhp', nomerHp).maybeSingle();
      if(existing!=null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nomer HP Sudah Terdaftar'))
        );
        return;
      }

      await supabase.from('pasien').insert({
        'nama' : nama,
        'gender' : gender,
        'umur' : umur,
        'pekerjaan' : pekerjaan,
        'alamat' : alamat,
        'nomerhp' : nomerHp,
        'user_id' : idPasien

      });
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const BerandaPasienScreen()));

    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Icon kembali & Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Image.asset(
                    'assets/LogoMedicall.png',
                    height: 60,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Nama
              const Text('Nama'),
              const SizedBox(height: 8),
              _buildTextField('ketik disini', namaController),

              const SizedBox(height: 16),

              // Gender
              const Text('Gender'),
              const SizedBox(height: 8),
              _buildTextField('laki-laki/perempuan', genderController),

              const SizedBox(height: 16),

              // Umur
              const Text('Umur'),
              const SizedBox(height: 8),
              _buildTextField('ketik disini', umurController),

              const SizedBox(height: 16),

              // Pekerjaan
              const Text('Pekerjaan'),
              const SizedBox(height: 8),
              _buildTextField('ketik disini', pekerjaanController),

              const SizedBox(height: 16),

              // Alamat
              const Text('Alamat'),
              const SizedBox(height: 8),
              _buildTextField('ketik disini', alamatController),

              const SizedBox(height: 16),

              // Nomor HP
              const Text('Nomer HP'),
              const SizedBox(height: 8),
              _buildTextField('ketik disini', nomerHpController),

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
    );
  }

  Widget _buildTextField(String hint, TextEditingController ct) {
    return TextField(
      controller: ct,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
