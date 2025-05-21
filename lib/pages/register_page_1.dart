import 'package:flutter/material.dart';
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
        'nomerhp' : nomerHp
      });
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));

    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
        );
    }
  } 
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
      ),
      body: ListView(
        children: [
          // nama
          TextField(
            decoration: const InputDecoration(labelText: "Nama"),
            controller: namaController,
          ),
          // gender
          TextField(
            controller: genderController,
            decoration: const InputDecoration(labelText: "laki-laki/perempuan"),
          ),
          // umur
          TextField(
            controller: umurController,
            decoration: const InputDecoration(labelText: "umur"),
          ),
          // pekerjaan
          TextField(
            controller: pekerjaanController,
            decoration: const InputDecoration(labelText: "pekerjaan"),
          ),
          // alamat
          TextField(
            controller: alamatController,
            decoration: const InputDecoration(labelText: "alamat"),
          ),
          // nomerhp
          TextField(
            controller: nomerHpController,
            decoration: const InputDecoration(labelText: "nomer hp"),
          ),
          // button
          ElevatedButton(
              onPressed: submitData,
              child: const Text("Lanjutkan")
          ),

        ],
      ),
    );
  }
}
