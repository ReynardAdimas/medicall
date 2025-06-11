import 'package:flutter/material.dart';
import 'package:supaaaa/obat/obat.dart'; // Pastikan path ini benar
import 'package:supaaaa/obat/obat_database.dart'; // Pastikan path ini benar
import 'package:supaaaa/obat/pages/obat_2.dart'; // Pastikan path ini benar

class Obat1 extends StatefulWidget {
  const Obat1({super.key});

  @override
  State<Obat1> createState() => _Obat1State();
}

class _Obat1State extends State<Obat1> {
  final ObatDatabase obatDatabase = ObatDatabase();
  final TextEditingController _searchController = TextEditingController();
  List<Obat> _allObats = []; // Mengubah tipe menjadi List<Obat>
  List<Obat> _filteredObats = []; // Mengubah tipe menjadi List<Obat>

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterObat);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterObat);
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi ini sekarang hanya akan memfilter _allObats dan memperbarui _filteredObats.
  // Panggilan setState() akan dilakukan di dalam fungsi ini.
  void _filterObat() {
    if (!mounted) return; // Pastikan widget masih di tree

    final String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // Jika query kosong, tampilkan semua obat dari _allObats
        _filteredObats = List.from(_allObats);
      } else {
        // Filter obat berdasarkan query pencarian
        _filteredObats = _allObats.where((obat) {
          return obat.nama.toLowerCase().contains(query);
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
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Inventaris Obat',
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
                hintText: 'cari nama obat',
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
              color: const Color(0xFFF2F0F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Nama Obat',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Stok',
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
          const SizedBox(height: 8),

          // Daftar Obat dari StreamBuilder
          Expanded(
            child: StreamBuilder<List<Obat>>(
              stream: obatDatabase.getObatStream(), // Menggunakan stream dari ObatDatabase
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Jika tidak ada data, pastikan list lokal dikosongkan dan tampilkan pesan
                  // Ini penting agar _allObats dan _filteredObats tidak menahan data lama.
                  if (_allObats.isNotEmpty || _filteredObats.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if(mounted) {
                        setState(() {
                          _allObats = [];
                          _filteredObats = [];
                        });
                      }
                    });
                  }
                  return const Center(
                    child: Text('Tidak ada data obat.'),
                  );
                }

                // Data sudah ada. Perbarui _allObats dan _filteredObats.
                // Penting: Lakukan ini di luar setState() utama StreamBuilder
                // dan panggil setState() hanya jika perubahan _allObats diperlukan
                // untuk memicu _filterObat().
                final List<Obat> newObats = snapshot.data!;

                // Periksa apakah data stream benar-benar berubah konten
                // Ini adalah perbandingan yang lebih baik daripada hanya perbandingan objek List.
                bool dataChanged = _allObats.length != newObats.length;
                if (!dataChanged) {
                  for (int i = 0; i < _allObats.length; i++) {
                    // Anda mungkin perlu ID atau properti unik lain untuk membandingkan objek Obat
                    // Di sini saya asumsikan perbandingan nama dan stok sudah cukup sederhana
                    if (_allObats[i].nama != newObats[i].nama || _allObats[i].stok != newObats[i].stok) {
                      dataChanged = true;
                      break;
                    }
                  }
                }

                if (dataChanged) {
                  // Gunakan addPostFrameCallback untuk memicu setState setelah build
                  // agar _filterObat dapat di panggil dengan aman.
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _allObats = newObats; // Perbarui data master
                        _filterObat(); // Terapkan filter ke data baru
                      });
                    }
                  });
                }

                // list obat
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: _filteredObats.length,
                  itemBuilder: (context, index) {
                    final obat = _filteredObats[index];

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  obat.nama,
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  obat.stok.toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (index < _filteredObats.length - 1)
                          const Divider(height: 1, color: Colors.grey),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke Obat2 dan tunggu hasilnya
          // StreamBuilder akan otomatis menangani refresh data.
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Obat2()),
          );
          // Tidak perlu memanggil setState() atau _filterObat() di sini lagi
          // karena StreamBuilder akan mendeteksi perubahan dari Supabase stream.
          // _filterObat() akan dipanggil secara otomatis di dalam StreamBuilder's builder.
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}