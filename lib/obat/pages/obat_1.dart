import 'package:flutter/material.dart';
import 'package:supaaaa/obat/obat_database.dart';
import 'package:supaaaa/obat/pages/obat_2.dart';

class Obat1 extends StatefulWidget {
  const Obat1({super.key});

  @override
  State<Obat1> createState() => _Obat1State();
}

class _Obat1State extends State<Obat1> {
  final ObatDatabase obatDatabase = ObatDatabase();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allObats = [];
  List<dynamic> _filteredObats = [];

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

  void _filterObat() {
    // Pastikan widget masih mounted sebelum memanggil setState
    if (!mounted) return;

    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredObats = List.from(_allObats);
      } else {
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
            child: StreamBuilder<List<dynamic>>(
              stream: obatDatabase.stream,
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
                  // Jika tidak ada data, pastikan list filtering juga kosong
                  _allObats = [];
                  _filteredObats = [];
                  return const Center(
                    child: Text('Tidak ada data obat.'),
                  );
                }

                // Data loaded
                // PENTING: Panggil _filterObat() setelah frame saat ini selesai dibangun
                // Ini mencegah setState() dipanggil selama fase build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Hanya update _allObats jika data dari snapshot berbeda
                  // Ini untuk mencegah rebuild yang tidak perlu jika stream tidak berubah
                  if (_allObats.length != snapshot.data!.length ||
                      !_allObats.every((element) => snapshot.data!.contains(element))) {
                    _allObats = snapshot.data!;
                    _filterObat();
                  }
                });

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
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Obat2())),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}