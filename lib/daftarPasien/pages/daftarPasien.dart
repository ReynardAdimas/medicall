import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk memformat tanggal
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'package:supaaaa/pendaftaranPasien/kunjungan_database.dart'; // Import KunjunganDatabase
import 'package:supaaaa/models/kunjungan_detail_pasien.dart'; // Import model KunjunganDetailPasien
import 'package:supaaaa/daftarPasien/pages/diagnosisPage1.dart'; // Sesuaikan path ini

class Daftarpasien extends StatefulWidget {
  const Daftarpasien({super.key});

  @override
  State<Daftarpasien> createState() => _DaftarpasienState();
}

class _DaftarpasienState extends State<Daftarpasien> {
  final TextEditingController _searchController = TextEditingController();
  final KunjunganDatabase _kunjunganDatabase = KunjunganDatabase(); // Inisialisasi database

  // Future untuk data kunjungan yang belum diperiksa
  late Future<List<KunjunganDetailPasien>> _unexaminedKunjunganData;

  // Untuk menyimpan semua data yang belum diperiksa dari future
  List<KunjunganDetailPasien> _allUnexaminedKunjungan = [];
  // Untuk data yang sudah difilter
  List<KunjunganDetailPasien> _filteredUnexaminedKunjungan = [];

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil data pasien yang belum diperiksa
    _fetchUnexaminedKunjungan();
    _searchController.addListener(_filterPasien);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPasien);
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengambil data kunjungan dengan status_diterima = true dan belum diperiksa
  Future<void> _fetchUnexaminedKunjungan() async {
    setState(() {
      // Panggil fungsi baru dari database untuk pasien yang belum diperiksa
      _unexaminedKunjunganData = _kunjunganDatabase.ambilKunjunganBelumDiperiksa();
    });
  }

  void _filterPasien() {
    // Pastikan widget masih mounted sebelum memanggil setState
    if (!mounted) return;

    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredUnexaminedKunjungan = List.from(_allUnexaminedKunjungan);
      } else {
        _filteredUnexaminedKunjungan = _allUnexaminedKunjungan.where((kunjungan) {
          // Gunakan operator ?. dan ?? '' untuk menangani nilai null pada nama pasien atau keluhan
          return (kunjungan.namaPasien?.toLowerCase() ?? '').contains(query) ||
              (kunjungan.keluhan?.toLowerCase() ?? '').contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          'Daftar Pasien Belum Diperiksa', // Ubah judul AppBar
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'cari nama pasien atau keluhan',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
            ),
          ),
          // Header Tabel
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F0F0), // Warna abu-abu muda
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Nama',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Hari, tgl',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Keluhan',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8), // Spasi antara header dan daftar

          // Daftar Pasien (sekarang menampilkan data kunjungan yang belum diperiksa)
          Expanded(
            child: FutureBuilder<List<KunjunganDetailPasien>>(
              future: _unexaminedKunjunganData, // Menggunakan future yang baru
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error memuat data: ${snapshot.error.toString()}'))
                    );
                  });
                  return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  _allUnexaminedKunjungan = []; // Reset jika tidak ada data
                  _filteredUnexaminedKunjungan = [];
                  return const Center(child: Text('Tidak ada pasien yang belum diperiksa.')); // Ubah teks
                } else {
                  // Data berhasil dimuat, simpan ke _allUnexaminedKunjungan
                  if (_allUnexaminedKunjungan.length != snapshot.data!.length ||
                      !_allUnexaminedKunjungan.every((element) => snapshot.data!.contains(element))) {
                    _allUnexaminedKunjungan = snapshot.data!;
                    // Lakukan filtering ulang setiap kali data stream berubah (jika ada)
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _filterPasien();
                    });
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: _filteredUnexaminedKunjungan.length,
                    itemBuilder: (context, index) {
                      final kunjungan = _filteredUnexaminedKunjungan[index];
                      // Format tanggal ke "Rabu, 16 April"
                      final DateFormat formatter = DateFormat('EEEE, dd MMMM', 'id_ID');
                      final String formattedDate = formatter.format(kunjungan.tanggalKunjungan);

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DiagnosaPage1(
                                    namaPasien: kunjungan.namaPasien ?? 'Nama Tidak Tersedia',
                                    keluhanPasien: kunjungan.keluhan ?? 'Tidak ada keluhan',
                                    tanggalKunjungan: kunjungan.tanggalKunjungan,
                                    kunjunganId: kunjungan.id, // Teruskan ID kunjungan jika perlu
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      kunjungan.namaPasien ?? 'Nama Tidak Tersedia',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      formattedDate,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      kunjungan.keluhan ?? 'Tidak ada keluhan',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index < _filteredUnexaminedKunjungan.length - 1)
                            const Divider(height: 1, color: Colors.grey),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
