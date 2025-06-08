import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supaaaa/models/rekam_medis_database.dart';

import 'diagnosisPage2.dart';

class DiagnosaPage1 extends StatefulWidget {
  final String namaPasien;
  final String keluhanPasien;
  final DateTime tanggalKunjungan;
  final int? kunjunganId;

  const DiagnosaPage1({
    super.key,
    required this.namaPasien,
    required this.keluhanPasien,
    required this.tanggalKunjungan,
    this.kunjunganId,
  });

  @override
  State<DiagnosaPage1> createState() => _DiagnosaPage1State();
}

class _DiagnosaPage1State extends State<DiagnosaPage1> {
  final TextEditingController _diagnosisController = TextEditingController();

  @override
  void dispose() {
    _diagnosisController.dispose();
    super.dispose();
  }

  void _masukkanObat() async {
    if(widget.kunjunganId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Id Kunjungan Tidak Tersedia'))
      );
      return;
    }

    if(_diagnosisController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Diagnosis Tidak Boleh Kosong'))
      );
      return;
    }

    try{
      int? rekamMedisId;
      rekamMedisId = await RekamMedisDatabase().getRekamMedisIdByKunjunganId(widget.kunjunganId!);
      if(rekamMedisId!=null) {
        print('Rekam Medis Sudah Ada');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pasien Sudah Diperiksa'))
        );

      }else {
        rekamMedisId = await RekamMedisDatabase().insertRekamMedis(
          kunjunganId: widget.kunjunganId!,
          namaPasien: widget.namaPasien,
          keluhanPasien: widget.keluhanPasien,
          tanggalKunjungan: widget.tanggalKunjungan,
          diagnosis: _diagnosisController.text,
        );
        if (rekamMedisId != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Diagnosispage2(rekamMedisId: rekamMedisId,)));
          print('Diagnosis berhasil disimpan dengan ID Rekam Medis baru: $rekamMedisId');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Terjadi Error saat Pemasukan Data Rekam Medis!'))
          );
          return;
        }
      }
    } catch(e) {
      print('Error saat menyimpan diagnosis: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Diagnosis Pasien',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informasi Pasien
            Text(
              'Pasien, ${widget.namaPasien}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24), // Spasi

            // Label Diagnosis Pasien
            const Text(
              'Diagnosis Pasien',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8), // Spasi antara label dan TextField

            // TextField Diagnosis Pasien (Multiline)
            TextField(
              controller: _diagnosisController,
              maxLines: 5, // Membuat TextField multiline
              decoration: InputDecoration(
                hintText: 'ketik disini',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            const SizedBox(height: 40), // Spasi sebelum tombol

            // Tombol "Masukkan Obat"
            SizedBox(
              width: double.infinity, // Lebar penuh
              height: 50, // Tinggi tombol
              child: ElevatedButton(
                onPressed: _masukkanObat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BC34A), // Warna hijau sesuai desain
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24), // Rounded corners
                  ),
                  elevation: 4, // Shadow tombol
                ),
                child: const Text(
                  "Masukkan Obat",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Teks putih
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
