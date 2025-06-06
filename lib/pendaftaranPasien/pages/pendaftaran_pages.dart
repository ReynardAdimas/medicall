import 'package:flutter/material.dart';
import 'package:supaaaa/pendaftaranPasien/kunjungan.dart';
import 'package:supaaaa/pendaftaranPasien/kunjungan_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // Tambahkan ini untuk memformat tanggal

class PendaftaranPages extends StatefulWidget {
  const PendaftaranPages({super.key});

  @override
  State<PendaftaranPages> createState() => _PendaftaranPagesState();
}

class _PendaftaranPagesState extends State<PendaftaranPages> {

  DateTime? _tanggaldipilih;
  final _keluhanController = TextEditingController();
  final _tanggalKunjunganController = TextEditingController();

  @override
  void dispose() {
    _keluhanController.dispose();
    _tanggalKunjunganController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggaldipilih ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _tanggaldipilih) {
      setState(() {
        _tanggaldipilih = picked;
        _tanggalKunjunganController.text = DateFormat('dd MMMM yyyy').format(_tanggaldipilih!);
      });
      print('Tanggal dipilih: $_tanggaldipilih'); // Debugging
    }
  }

  Future<void> savePendaftaran() async {
    if(_tanggaldipilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tanggal kunjungan harus diisi!"))
      );
      return;
    }
    final tanggalKunjungan = _tanggaldipilih;
    final keluhan = _keluhanController.text;
    try {
      await KunjunganDatabase().tambahKunjungan(
        tanggalKunjungan: tanggalKunjungan,
        keluhan: keluhan,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran Berhasil'))
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error saat menyimpan pendaftaran: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi Kesalahan: ${e.toString()}')) // Tampilkan errornya
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Pendaftaran")
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _tanggalKunjunganController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: const InputDecoration(
                labelText: 'Tanggal Kunjungan',
                hintText: 'Pilih tanggal kunjungan',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 12,),

            TextField(
              controller: _keluhanController,
              decoration: const InputDecoration(
                labelText: 'Keluhan',
                hintText: 'Masukkan keluhan pasien',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24,), // Spasi sebelum tombol

            ElevatedButton(
              onPressed: savePendaftaran,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Simpan Pendaftaran",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}