import 'package:flutter/material.dart';
import 'package:supaaaa/pendaftaranPasien/kunjungan_database.dart';
import 'package:supaaaa/models/kunjungan_detail_pasien.dart';
import 'package:intl/intl.dart';

class Jadwalkunjungan extends StatefulWidget {
  const Jadwalkunjungan({super.key});

  @override
  State<Jadwalkunjungan> createState() => _JadwalkunjunganState();
}

class _JadwalkunjunganState extends State<Jadwalkunjungan> {
  late Future<List<KunjunganDetailPasien>> _kunjunganData;

  @override
  void initState() {
    super.initState();
    _kunjunganData = KunjunganDatabase().ambilSemuaKunjungan();
  }

  // Fungsi untuk me-refresh data
  Future<void> _refreshData() async {
    setState(() {
      _kunjunganData = KunjunganDatabase().ambilSemuaKunjungan();
    });
  }

  // Callback yang akan dipanggil dari KunjunganListItem setelah update
  void _onKunjunganStatusChanged() {
    _refreshData(); // Panggil refresh data saat status berubah
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jadwal Kunjungan',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // Hapus shadow AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20), // Spasi di atas header tabel
            // Header Tabel
            Container(
              width: double.infinity,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 9),
              decoration: ShapeDecoration(
                color: const Color(0xFFF2F0F0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Mengatur jarak antar kolom
                children: const [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Nama',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Hari, Tgl',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Aksi', // Ini bisa jadi status atau jenis kunjungan
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Garis pembatas di bawah header
            Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xFFD9D9D9),
            ),
            Expanded(
              child: FutureBuilder<List<KunjunganDetailPasien>>(
                future: _kunjunganData,
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
                    return const Center(child: Text('Tidak ada jadwal kunjungan.'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final kunjungan = snapshot.data![index];
                        return KunjunganListItem(
                          kunjungan: kunjungan,
                          onStatusChanged: _onKunjunganStatusChanged,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KunjunganListItem extends StatelessWidget {
  final KunjunganDetailPasien kunjungan;
  final VoidCallback onStatusChanged;

  const KunjunganListItem({super.key, required this.kunjungan, required this.onStatusChanged});

  Future<void> _updateKunjunganStatus(BuildContext context, bool statusDiterima) async {
    try {
      await KunjunganDatabase().updateKunjungan(
          kunjungan.id,
          {
            'status_diterima': statusDiterima,
            'status_kunjungan' : statusDiterima ? 'done' : 'waiting'
          });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kunjungan ${statusDiterima? 'diterima' : 'ditolak'}!'))
      );
      onStatusChanged();
    } catch (e) {
      print('Error saat memperbarui status kunjungan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui status kunjungan: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('EEEE, dd MMMM', 'id_ID');
    final String formattedDate = formatter.format(kunjungan.tanggalKunjungan);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 13),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFFD9D9D9),
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              kunjungan.namaPasien ?? 'Nama Tidak Tersedia', // <-- Gunakan operator ??
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              formattedDate,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  onPressed: () => _updateKunjunganStatus(context, true),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                //const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red, size: 20),
                  onPressed: () => _updateKunjunganStatus(context, false),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
