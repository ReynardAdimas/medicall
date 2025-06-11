import 'package:flutter/material.dart';
import 'package:supaaaa/models/rekam_medis_database.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class RiwayatKunjungan2 extends StatefulWidget {
  final String patientName;

  const RiwayatKunjungan2({super.key, required this.patientName});

  @override
  State<RiwayatKunjungan2> createState() => _RiwayatKunjungan2State();
}

class _RiwayatKunjungan2State extends State<RiwayatKunjungan2> {
  late RekamMedisDatabase _database;
  List<Map<String, dynamic>> _rekamMedisList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _database = RekamMedisDatabase();
    _fetchRekamMedisDetails();
  }

  Future<void> _fetchRekamMedisDetails() async {
    try {
      // Get all rekam medis records for the given patient name
      final List<Map<String, dynamic>> patientRecords =
      await _database.getRekamMedisByNamaPasien(widget.patientName);

      List<Map<String, dynamic>> detailedRecords = [];
      for (var record in patientRecords) {
        final int rekamMedisId = record['id'];
        final Map<String, dynamic>? detail =
        await _database.getRekamMedisDetailWithObat(rekamMedisId);
        if (detail != null) {
          detailedRecords.add(detail);
        }
      }

      setState(() {
        _rekamMedisList = detailedRecords;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching rekam medis details: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat detail kunjungan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Riwayat Kunjungan ${widget.patientName}', // Display patient name in title
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rekamMedisList.isEmpty
          ? const Center(child: Text('Tidak ada riwayat kunjungan ditemukan.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _rekamMedisList.length,
        itemBuilder: (context, index) {
          final record = _rekamMedisList[index];
          final String tanggalKunjungan = record['tanggal_kunjungan'];
          final String keluhan = record['keluhan'];
          final String diagnosa = record['diagnosa'];
          final List<dynamic> obatDigunakan = record['obat_digunakan'];

          // Format the date
          final DateTime dateTime = DateTime.parse(tanggalKunjungan);
          final String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);

          // Combine obat names and quantities
          String obatInfo = 'Tidak ada obat';
          if (obatDigunakan.isNotEmpty) {
            obatInfo = obatDigunakan.map((obat) {
              return '${obat['nama_obat']} (${obat['jumlah_digunakan']})';
            }).join(', ');
          }

          return Column(
            children: [
              _buildKunjunganCard(
                tanggal: formattedDate,
                keluhan: keluhan,
                diagnosis: diagnosa,
                namaObat: obatInfo,
                jumlahObat: obatDigunakan.length, // Or use the sum of quantities if needed
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKunjunganCard({
    required String tanggal,
    required String keluhan,
    required String diagnosis,
    required String namaObat,
    required int jumlahObat,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                tanggal,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Divider(height: 20, thickness: 1),
            _buildInfoRow('Keluhan:', keluhan),
            _buildInfoRow('Diagnosis:', diagnosis),
            _buildInfoRow('Obat:', namaObat), // Display combined obat information
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}