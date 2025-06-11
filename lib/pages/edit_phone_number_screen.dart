// lib/pages/edit_phone_number_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPhoneNumberScreen extends StatefulWidget {
  final String currentPhoneNumber; // Nomor HP saat ini yang akan diedit
  final String userUuid; // User ID (UUID) dari pengguna yang sedang login

  const EditPhoneNumberScreen({
    super.key,
    required this.currentPhoneNumber,
    required this.userUuid,
  });

  @override
  State<EditPhoneNumberScreen> createState() => _EditPhoneNumberScreenState();
}

class _EditPhoneNumberScreenState extends State<EditPhoneNumberScreen> {
  final TextEditingController _newPhoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Kunci global untuk form validasi

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nomor telepon saat ini (tanpa +62)
    String initialNumber = widget.currentPhoneNumber.startsWith('+62')
        ? widget.currentPhoneNumber.substring(3) // Hapus +62
        : widget.currentPhoneNumber;
    _newPhoneNumberController.text = initialNumber;
  }

  @override
  void dispose() {
    _newPhoneNumberController.dispose();
    super.dispose();
  }

  // Fungsi validasi untuk nomor handphone Indonesia
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor handphone tidak boleh kosong';
    }

    // Hapus spasi atau karakter non-digit lainnya
    String cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');

    // Cek panjang setelah format +62 (7-12 digit)
    if (cleanedValue.length < 7 || cleanedValue.length > 12) {
      return 'Panjang nomor handphone tidak valid (7-12 digit setelah +62)';
    }

    return null; // Return null jika valid
  }

  // Fungsi untuk update nomor handphone di database Supabase
  Future<void> _updatePhoneNumber() async {
    if (!_formKey.currentState!.validate()) {
      return; // Berhenti jika validasi gagal
    }

    final supabase = Supabase.instance.client;
    String newNumber = _newPhoneNumberController.text.replaceAll(RegExp(r'[^\d]'), ''); // Bersihkan lagi
    String formattedNewNumber = '+62' + newNumber; // Tambahkan +62 untuk format internasional

    // Jika nomor tidak berubah, tidak perlu update
    if (formattedNewNumber == widget.currentPhoneNumber) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor handphone tidak berubah.')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
      return;
    }

    try {
      // Cek redundansi nomor HP baru di tabel pasien (jika ada user lain pakai nomor ini)
      final existing = await supabase
          .from('pasien')
          .select('user_id')
          .eq('nomerhp', formattedNewNumber)
          .maybeSingle();

      if (existing != null && existing['user_id'] != widget.userUuid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nomor handphone ini sudah terdaftar oleh pengguna lain.')),
        );
        return;
      }

      // Lakukan update di tabel 'pasien'
      await supabase
          .from('pasien')
          .update({'nomerhp': formattedNewNumber})
          .eq('user_id', widget.userUuid); // Update berdasarkan user_id

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor handphone berhasil diperbarui!')),
      );
      Navigator.pop(context, true); // Kembali dan kirim sinyal 'true' bahwa update berhasil
    } catch (e) {
      print('Error updating phone number: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui nomor handphone: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Ubah Nomer Ponsel',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Nomer Ponsel Baru',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _newPhoneNumberController,
                keyboardType: TextInputType.phone,
                validator: _validatePhoneNumber,
                decoration: InputDecoration(
                  hintText: 'Cth: 8282342774',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Bendera Indonesia (bisa diganti dengan Image.asset jika ada)
                        Text(
                          '🇮🇩',
                          style: TextStyle(fontSize: 24), // Ukuran yang lebih besar
                        ),
                        SizedBox(width: 8),
                        Text(
                          '+62',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none, // Menghilangkan border default
                  ),
                  filled: true,
                  fillColor: Colors.grey[200], // Warna latar belakang field
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _updatePhoneNumber,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}