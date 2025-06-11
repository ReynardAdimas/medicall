import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

class CekJadwalScreen extends StatefulWidget {
  const CekJadwalScreen({super.key});

  @override
  State<CekJadwalScreen> createState() => _CekJadwalScreenState();
}

class _CekJadwalScreenState extends State<CekJadwalScreen> {
  // State untuk melacak filter jadwal yang dipilih (Selesai, Batal)
  // Default filter sekarang adalah 'Selesai'
  String _selectedFilter = 'Selesai';

  // State untuk menyimpan daftar kunjungan yang dimuat dari Supabase
  List<Map<String, dynamic>> _kunjunganList = [];
  bool _isLoading = true; // State untuk indikator loading

  @override
  void initState() {
    super.initState();
    _fetchKunjunganData(); // Panggil fungsi untuk mengambil data saat pertama kali dimuat
  }

  // Fungsi untuk mengambil data kunjungan dari Supabase
  Future<void> _fetchKunjunganData() async {
    setState(() {
      _isLoading = true; // Set loading true saat memulai pengambilan data
    });

    final supabase = Supabase.instance.client;
    final User? currentUser = supabase.auth.currentUser;

    if (currentUser == null) {
      print('Tidak ada pengguna yang login.');
      setState(() {
        _isLoading = false;
        _kunjunganList = []; // Kosongkan daftar jika tidak ada user
      });
      return;
    }

    try {
      // Base query
      // Menambahkan 'pasien(nama)' dalam select untuk mengambil nama pasien
      var query = supabase
          .from('kunjungan')
          .select('id, tanggal_kunjungan, keluhan, status_kunjungan, status_diterima, pasien(nama)')
          .eq('id_pasien', currentUser.id); // Filter berdasarkan user_id yang sedang login

      // Apply filters based on _selectedFilter
      // Menghapus kondisi untuk 'Jadwal' karena tombolnya sudah dihapus
      if (_selectedFilter == 'Selesai') {
        query = query
            .eq('status_diterima', true)
            .eq('status_kunjungan', 'done');
      } else if (_selectedFilter == 'Batal') {
        query = query
            .eq('status_diterima', false)
            .eq('status_kunjungan', 'rejected');
      }

      final List<Map<String, dynamic>> data = await query.order('tanggal_kunjungan', ascending: true); // Urutkan berdasarkan tanggal

      setState(() {
        _kunjunganList = data;
        _isLoading = false; // Set loading false setelah data dimuat
      });
    } catch (e) {
      print('Error fetching kunjungan data: $e');
      setState(() {
        _isLoading = false; // Set loading false meskipun ada error
        _kunjunganList = []; // Kosongkan daftar jika terjadi error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat jadwal: ${e.toString()}')),
      );
    }
  }

  // Fungsi untuk memperbarui status kunjungan (membatalkan atau menyelesaikan)
  Future<void> _updateKunjunganStatus(int kunjunganId, String newStatusKunjungan, bool newStatusDiterima) async {
    setState(() {
      _isLoading = true; // Tampilkan loading saat update
    });
    final supabase = Supabase.instance.client;
    try {
      await supabase
          .from('kunjungan')
          .update({
        'status_kunjungan': newStatusKunjungan,
        'status_diterima': newStatusDiterima,
      })
          .eq('id', kunjunganId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Jadwal berhasil diperbarui')),
      );
      _fetchKunjunganData(); // Muat ulang data setelah update
    } catch (e) {
      print('Error updating kunjungan status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui jadwal: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Latar belakang abu-abu muda
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Jadwal Kamu',
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
        children: [
          // Filter Buttons (Selesai, Batal)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Menghapus tombol 'Jadwal'
                // _buildFilterButton('Jadwal'),
                _buildFilterButton('Selesai'),
                _buildFilterButton('Batal'),
              ],
            ),
          ),
          // List of Kunjungan Cards
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _kunjunganList.isEmpty
                ? Center(
              child: Text(
                'Tidak ada jadwal dengan status "${_selectedFilter.toLowerCase()}"',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _kunjunganList.length,
              itemBuilder: (context, index) {
                final kunjungan = _kunjunganList[index];
                final DateTime tanggalKunjungan = DateTime.parse(kunjungan['tanggal_kunjungan']);
                final String formattedDate = DateFormat('EEEE, dd/MM/yyyy', 'id_ID').format(tanggalKunjungan);
                const String jamKunjungan = '16.00'; // Sesuaikan jika ada kolom jam

                final String pasienNama = kunjungan['pasien'] != null && kunjungan['pasien']['nama'] != null
                    ? kunjungan['pasien']['nama'] as String
                    : 'Nama Tidak Ditemukan'; // Fallback

                return _buildKunjunganCard(
                  id: kunjungan['id'],
                  namaPasien: pasienNama,
                  keluhan: kunjungan['keluhan'] ?? 'Tidak ada keluhan',
                  tanggal: formattedDate,
                  jam: jamKunjungan,
                  statusKunjungan: kunjungan['status_kunjungan'],
                  statusDiterima: kunjungan['status_diterima'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk tombol filter
  Widget _buildFilterButton(String filterText) {
    final bool isSelected = _selectedFilter == filterText;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedFilter = filterText;
            });
            _fetchKunjunganData(); // Muat ulang data saat filter berubah
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.lightGreen : Colors.white,
            foregroundColor: isSelected ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: isSelected ? Colors.lightGreen : Colors.grey.shade300),
            ),
            elevation: isSelected ? 2 : 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            filterText,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Helper widget untuk kartu jadwal kunjungan
  Widget _buildKunjunganCard({
    required int id,
    required String namaPasien,
    required String keluhan,
    required String tanggal,
    required String jam,
    required String statusKunjungan,
    required bool statusDiterima,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Pasien dan Keluhan
            Row(
              children: [
                const Icon(Icons.person, color: Colors.grey, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaPasien,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        keluhan,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Tanggal dan Jam
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Text(
                  tanggal,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.access_time, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Text(
                  jam,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Action Buttons based on Status
            _buildActionButtons(id, statusKunjungan, statusDiterima),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk tombol aksi berdasarkan status
  Widget _buildActionButtons(int kunjunganId, String statusKunjungan, bool statusDiterima) {
    // Tombol Batalkan dan Ubah Jadwal hanya muncul jika statusnya 'Jadwal'
    // Karena sekarang filter 'Jadwal' dihapus, maka tidak ada aksi di sini
    // untuk mengubah status menjadi 'selesai' atau 'batal' dari tampilan ini,
    // karena tombol-tombol itu akan dikelola oleh admin/dokter.
    // Jika Anda ingin mengizinkan user membatalkan dari sini, Anda perlu menambahkan tombolnya.
    if (statusDiterima == true && statusKunjungan == 'waiting') {
      // Ini adalah kondisi "Jadwal" yang sebelumnya memiliki tombol "Batalkan" dan "Ubah Jadwal"
      // Jika Anda tidak ingin menampilkan ini, Anda bisa menghapus bagian ini.
      // Namun, jika Anda ingin user tetap bisa membatalkan jadwal yang waiting
      // meskipun tab 'Jadwal' tidak ada, Anda perlu memikirkan ulang alur UX.
      // Untuk tujuan demo ini, saya akan menyertakan contoh tombol batalkan.
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                _updateKunjunganStatus(kunjunganId, 'waiting', false); // Ubah status_diterima ke false, status_kunjungan tetap waiting
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Batalkan'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fungsi Ubah Jadwal belum diimplementasikan.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Ubah Jadwal', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    } else if (statusDiterima == true && statusKunjungan == 'done') { // Status: Selesai
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null, // Tombol non-aktif
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade100, // Warna latar belakang hijau muda
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            'Selesai',
            style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else if (statusDiterima == false && statusKunjungan == 'rejected') { // Status: Batal
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null, // Tombol non-aktif
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade100, // Warna latar belakang merah muda
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            'Dibatalkan',
            style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return const SizedBox.shrink(); // Widget kosong jika status tidak dikenal
  }
}