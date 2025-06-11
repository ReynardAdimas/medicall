import 'package:flutter/material.dart';
import 'package:supaaaa/models/rekam_medis_database.dart';
import 'riwayatKunjungan2.dart';

class Riwayatkunjungan1 extends StatefulWidget {
  const Riwayatkunjungan1({super.key});

  @override
  State<Riwayatkunjungan1> createState() => _Riwayatkunjungan1State();
}

class _Riwayatkunjungan1State extends State<Riwayatkunjungan1> {
  // Instance database
  late RekamMedisDatabase _database;

  // Daftar nama pasien yang dimuat dari database
  List<String> _patientNames = [];

  // Controller untuk field pencarian teks
  final TextEditingController _searchController = TextEditingController();

  // Daftar nama pasien yang difilter berdasarkan query pencarian
  List<String> _filteredPatientNames = [];

  // Status loading untuk menunjukkan apakah data sedang dimuat
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _database = RekamMedisDatabase(); // Inisialisasi database
    _fetchPatientNames(); // Panggil fungsi untuk mengambil data pasien
    _searchController.addListener(_filterPatients); // Tambahkan listener untuk pencarian
  }

  // Metode untuk mengambil nama pasien dari database
  Future<void> _fetchPatientNames() async {
    try {
      // Panggil fungsi getRecordsByStatusKunjungan dengan status_kunjungan = true
      final List<Map<String, dynamic>> records = await _database.getRiwayatNamaList(true);

      setState(() {
        // Ekstrak 'nama_pasien' dari setiap map yang diterima dari Supabase
        _patientNames = records.map((record) => record['nama_pasien'].toString()).toList();
        _filteredPatientNames = _patientNames; // Inisialisasi daftar yang difilter dengan semua nama
        _isLoading = false; // Data selesai dimuat
      });
    } catch (e) {
      // Tangkap dan cetak error jika terjadi masalah saat mengambil data
      print('Error fetching patient names: $e');
      setState(() {
        _isLoading = false; // Hentikan loading meskipun ada error
      });
      // Tampilkan SnackBar untuk memberi tahu pengguna jika ada kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data pasien: $e')),
      );
    }
  }

  @override
  void dispose() {
    // Buang listener dan controller saat widget dihapus dari tree
    _searchController.removeListener(_filterPatients);
    _searchController.dispose();
    super.dispose();
  }

  // Metode untuk memfilter nama pasien berdasarkan input pencarian
  void _filterPatients() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatientNames = _patientNames
          .where((patient) => patient.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Kembali ke halaman sebelumnya
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Daftar Kunjungan Pasien'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'cari nama pasien',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ),
          ),
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Nama',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator()) // Tampilkan indikator loading saat data sedang dimuat
                : _filteredPatientNames.isEmpty
                ? const Center(child: Text('Tidak ada pasien ditemukan.')) // Pesan jika tidak ada data pasien
                : ListView.builder(
              itemCount: _filteredPatientNames.length,
              itemBuilder: (context, index) {
                final patientName = _filteredPatientNames[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigasi ke RiwayatKunjungan2 dan kirim nama pasien
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RiwayatKunjungan2(patientName: patientName),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                patientName,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    // Tambahkan divider tipis di bawah setiap item
                    Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}