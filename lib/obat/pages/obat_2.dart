import 'package:flutter/material.dart';
import 'package:supaaaa/obat/obat.dart';
import 'package:supaaaa/obat/obat_database.dart';

class Obat2 extends StatefulWidget {
  const Obat2({super.key});

  @override
  State<Obat2> createState() => _Obat2State();
}

class _Obat2State extends State<Obat2> {
  final ObatDatabase obatDatabase = ObatDatabase(); // Pastikan ini diinisialisasi dengan benar

  final TextEditingController namaController = TextEditingController();
  final TextEditingController stokController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    stokController.dispose();
    super.dispose();
  }

  void saveObat() async {
    final nama = namaController.text.trim(); // Hapus spasi di awal/akhir
    final int? stokInput = int.tryParse(stokController.text.trim()); // Ambil stok input sebagai int?

    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama Obat tidak boleh kosong!'))
      );
      return;
    }
    if (stokInput == null || stokInput <= 0) { // Validasi stok input
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stok Obat harus berupa angka positif!'))
      );
      return;
    }

    try {
      final Obat? existingObat = await obatDatabase.getObatByName(nama);

      if (existingObat != null) {

        final int newTotalStok = existingObat.stok + stokInput;
        await obatDatabase.updateObat(existingObat.id!, {'stok': newTotalStok}); // ID tidak akan null di sini
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Stok obat "$nama" berhasil ditambahkan menjadi $newTotalStok!'))
        );
      } else {
        final newObat = Obat(nama: nama, stok: stokInput);
        await obatDatabase.createObat(newObat);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Obat baru berhasil disimpan!'))
        );
      }

      Navigator.pop(context, true); // Kembali ke halaman sebelumnya dan beri sinyal sukses
    } catch (e) {
      print('Error saat menyimpan/memperbarui obat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan/memperbarui obat: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Hapus shadow AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          'Inventaris Obat',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Montserrat', // Atau font lain yang Anda gunakan
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Padding keseluruhan
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri untuk label
          children: [
            // Label Nama Obat
            const Text(
              'Nama Obat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8), // Spasi antara label dan TextField
            // TextField Nama Obat
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                hintText: 'ketik disini',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
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
            const SizedBox(height: 24), // Spasi antara TextField

            // Label Stok
            const Text(
              'Stok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8), // Spasi antara label dan TextField
            // TextField Stok
            TextField(
              controller: stokController,
              keyboardType: TextInputType.number, // Hanya izinkan input angka
              decoration: InputDecoration(
                hintText: 'cth: 1',
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
            const SizedBox(height: 40), // Spasi sebelum tombol simpan

            // Tombol Simpan
            SizedBox( // Menggunakan SizedBox untuk mengatur lebar tombol
              width: double.infinity, // Membuat tombol selebar mungkin
              height: 50, // Tinggi tombol
              child: ElevatedButton(
                onPressed: saveObat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BC34A), // Warna hijau sesuai desain
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24), // Rounded corners
                  ),
                  elevation: 4, // Shadow tombol
                ),
                child: const Text(
                  "Simpan",
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
