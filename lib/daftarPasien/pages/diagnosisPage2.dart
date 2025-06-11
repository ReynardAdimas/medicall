import 'package:flutter/material.dart';
import 'package:supaaaa/models/rekam_medis_database.dart';

class Diagnosispage2 extends StatefulWidget {
  final int? rekamMedisId;
  const Diagnosispage2({super.key, required this.rekamMedisId});

  @override
  State<Diagnosispage2> createState() => _Diagnosispage2State();
}

class _Diagnosispage2State extends State<Diagnosispage2> {
  final TextEditingController _jumlahObatDibutuhkanController =
  TextEditingController();
  int _numberOfMedicineFields = 0;
  List<String?> _selectedMedicinesNames = [];
  List<int?> _selectedMedicinesIds = [];
  List<TextEditingController> _jumlahObatControllers = [];

  final RekamMedisDatabase _rekamMedisDatabase = RekamMedisDatabase();
  // Akan diisi dengan daftar obat yang stoknya > 0
  List<Map<String, dynamic>> _medicineOptions = [];

  @override
  void initState() {
    super.initState();
    // Ambil daftar obat yang stoknya > 0 saat inisialisasi
    _fetchMedicineOptions();
    _jumlahObatDibutuhkanController.addListener(_updateMedicineFields);
  }

  @override
  void dispose() {
    _jumlahObatDibutuhkanController.removeListener(_updateMedicineFields);
    _jumlahObatDibutuhkanController.dispose();
    for (var controller in _jumlahObatControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Fungsi untuk mengambil dan memfilter daftar obat dari database
  Future<void> _fetchMedicineOptions() async {
    try {
      // 1. Ambil semua daftar obat dari database
      final List<Map<String, dynamic>> allObatList = await _rekamMedisDatabase.getObatList();

      // 2. Filter daftar obat: hanya sertakan yang stoknya lebih dari 0
      final List<Map<String, dynamic>> filteredObatList = allObatList.where((medicine) {
        // Pastikan kunci 'stok' ada dan nilainya adalah integer yang valid
        // Jika 'stok' tidak ada atau bukan angka, anggap stoknya 0 atau kurang
        return medicine.containsKey('stok') && (medicine['stok'] is int) && (medicine['stok'] > 0);
      }).toList();

      setState(() {
        _medicineOptions = filteredObatList;
      });
      print('Daftar Obat (stok > 0) berhasil dimuat: $_medicineOptions');
    } catch (e) {
      print('Error fetching filtered medicine options: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat daftar obat: ${e.toString()}'))
      );
    }
  }

  // Method to update the number of dynamically generated medicine input fields
  void _updateMedicineFields() {
    if (!mounted) return;

    int? newCount = int.tryParse(_jumlahObatDibutuhkanController.text);
    if (newCount != null && newCount >= 0) {
      setState(() {
        _numberOfMedicineFields = newCount;

        // Sesuaikan ukuran daftar nama dan ID obat yang dipilih
        while (_selectedMedicinesNames.length < _numberOfMedicineFields) {
          _selectedMedicinesNames.add(null);
          _selectedMedicinesIds.add(null);
        }
        while (_selectedMedicinesNames.length > _numberOfMedicineFields) {
          _selectedMedicinesNames.removeLast();
          _selectedMedicinesIds.removeLast();
        }

        // Sesuaikan ukuran daftar controller jumlah obat
        while (_jumlahObatControllers.length < _numberOfMedicineFields) {
          _jumlahObatControllers.add(TextEditingController());
        }
        while (_jumlahObatControllers.length > _numberOfMedicineFields) {
          _jumlahObatControllers.last.dispose();
          _jumlahObatControllers.removeLast();
        }
      });
    } else if (_jumlahObatDibutuhkanController.text.isEmpty) {
      setState(() {
        _numberOfMedicineFields = 0;
        _selectedMedicinesNames.clear();
        _selectedMedicinesIds.clear();
        for (var controller in _jumlahObatControllers) {
          controller.dispose();
        }
        _jumlahObatControllers.clear();
      });
    }
  }

  // Method to handle saving the entered data
  void _saveData() async {
    if (_numberOfMedicineFields == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jumlah obat yang dibutuhkan harus diisi!'))
      );
      return;
    }

    List<Map<String, dynamic>> obatToSave = [];
    for (int i = 0; i < _numberOfMedicineFields; i++) {
      if (_selectedMedicinesIds[i] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Obat ke-${i + 1} belum dipilih!'))
        );
        return;
      }
      int? jumlah = int.tryParse(_jumlahObatControllers[i].text);
      if (jumlah == null || jumlah <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Jumlah obat ke-${i + 1} tidak valid!'))
        );
        return;
      }

      // Pastikan obat yang dipilih masih memiliki stok yang mencukupi
      // Dapatkan data obat terbaru dari _medicineOptions
      final selectedMedicineData = _medicineOptions.firstWhere(
            (element) => element['id'] == _selectedMedicinesIds[i],
        orElse: () => <String, dynamic>{'stok': 0}, // Fallback jika tidak ditemukan
      );

      final int currentStok = selectedMedicineData['stok'] as int? ?? 0;
      if (jumlah > currentStok) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Stok "${_selectedMedicinesNames[i]}" tidak mencukupi. Stok tersedia: $currentStok'))
        );
        return;
      }

      obatToSave.add({
        'obat_id': _selectedMedicinesIds[i],
        'jumlah_digunakan': jumlah,
      });
    }

    try {
      final bool success = await _rekamMedisDatabase.updateRekamMedisAndObatStok(
        rekamMedisId: widget.rekamMedisId!,
        selectedObatList: obatToSave,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil diperbarui'))
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Terjadi Kesalahan saat menyimpan data'))
        );
      }
    } catch (e) {
      print('Error saat menyimpan data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Masukkan Obat'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jumlah Obat yang dibutuhkan',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _jumlahObatDibutuhkanController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'cth: 2',
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Dynamically generated medicine input fields based on _numberOfMedicineFields
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _numberOfMedicineFields,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daftar Obat',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedMedicinesNames[index],
                              hint: const Text('Pilih Obat'),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                              ),
                              // Gunakan `_medicineOptions` yang sudah difilter
                              items: _medicineOptions.map((Map<String, dynamic> medicine) {
                                return DropdownMenuItem<String>(
                                  // Asumsi nama kolom untuk nama obat adalah 'nama'
                                  value: medicine['nama'] as String,
                                  child: Text('${medicine['nama'] as String} (Stok: ${medicine['stok']})'),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMedicinesNames[index] = newValue;
                                  // Temukan ID obat yang sesuai dari daftar yang difilter
                                  _selectedMedicinesIds[index] = _medicineOptions
                                      .firstWhere((element) => element['nama'] == newValue)['id'] as int?;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Jumlah Obat',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _jumlahObatControllers[index],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'cth: 1',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Save button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

