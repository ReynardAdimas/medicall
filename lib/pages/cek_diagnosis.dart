import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

class CekDiagnosis extends StatefulWidget {
  const CekDiagnosis({super.key});

  @override
  State<CekDiagnosis> createState() => _CekDiagnosisState();
}

class _CekDiagnosisState extends State<CekDiagnosis> {
  List<Map<String, dynamic>> _diagnosisList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDiagnosisData();
  }

  // Fungsi untuk mengambil data diagnosis dari Supabase
  Future<void> _fetchDiagnosisData() async {
    setState(() {
      _isLoading = true; // Set loading true
    });

    final supabase = Supabase.instance.client;
    final User? currentUser = supabase.auth.currentUser;

    if (currentUser == null) {
      print('Tidak ada pengguna yang login.');
      setState(() {
        _isLoading = false;
        _diagnosisList = [];
      });
      return;
    }

    try {
      // Ambil ID pasien dari tabel pasien berdasarkan user_id yang sedang login
      final pasienResponse = await supabase
          .from('pasien')
          .select('user_id') // Ambil user_id dari tabel pasien
          .eq('user_id', currentUser.id)
          .single();

      if (pasienResponse == null || pasienResponse['user_id'] == null) {
        print('Data pasien tidak ditemukan untuk user ini.');
        setState(() {
          _isLoading = false;
          _diagnosisList = [];
        });
        return;
      }

      final String pasienUuid = pasienResponse['user_id'] as String;

      // Sekarang ambil data rekam_medis yang terkait dengan kunjungan
      // dan kunjungan tersebut terkait dengan id_pasien (UUID) yang sesuai
      // Kita perlu join implisit dari rekam_medis -> kunjungan -> pasien
      final List<Map<String, dynamic>> data = await supabase
          .from('rekam_medis')
          .select('tanggal_kunjungan, keluhan, diagnosa, kunjungan!inner(id_pasien)') // Pilih kolom dari rekam_medis, dan id_pasien dari kunjungan
          .eq('kunjungan.id_pasien', pasienUuid) // Filter berdasarkan id_pasien dari tabel kunjungan
          .order('tanggal_kunjungan', ascending: false); // Urutkan dari tanggal terbaru
      setState(() {
        _diagnosisList = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching diagnosis data: $e');
      setState(() {
        _isLoading = false;
        _diagnosisList = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data diagnosis: ${e.toString()}')),
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
          'Diagnosis',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 10.0),
            child: Text(
              'Diagnosis dari bidan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _diagnosisList.isEmpty
                ? Center(
              child: Text(
                'Tidak ada riwayat diagnosis.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _diagnosisList.length,
              itemBuilder: (context, index) {
                final diagnosis = _diagnosisList[index];
                final DateTime tanggalKunjungan = DateTime.parse(diagnosis['tanggal_kunjungan']);
                final String formattedDate = DateFormat('EEEE, dd/MM/yyyy', 'id_ID').format(tanggalKunjungan);
                final String keluhan = diagnosis['keluhan'] ?? 'Tidak ada keluhan';
                final String diagnosaTeks = diagnosis['diagnosa'] ?? 'Tidak ada diagnosis';

                return _buildDiagnosisCard(
                  tanggal: formattedDate,
                  keluhan: keluhan,
                  diagnosis: diagnosaTeks,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk membangun kartu diagnosis
  Widget _buildDiagnosisCard({
    required String tanggal,
    required String keluhan,
    required String diagnosis,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tanggal,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Divider(height: 15, thickness: 1, color: Colors.grey),
            Text(
              'Keluhan: $keluhan',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Diagnosis: $diagnosis',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}