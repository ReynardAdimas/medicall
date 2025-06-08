import 'package:supabase_flutter/supabase_flutter.dart';

class RekamMedisDatabase {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fungsi untuk menyimpan data diagnosis ke tabel rekam_medis
  Future<int?> insertRekamMedis({
    required int kunjunganId,
    required String namaPasien,
    required String keluhanPasien,
    required DateTime tanggalKunjungan,
    required String diagnosis,
  }) async {
    try {
      final response = await _supabase.from('rekam_medis').insert({
        'kunjungan_id': kunjunganId,
        'nama_pasien': namaPasien,
        'keluhan': keluhanPasien,
        'tanggal_kunjungan': tanggalKunjungan.toIso8601String(),
        'diagnosa': diagnosis,
        'status_kunjungan' : true,
        // Tambahkan created_at dan updated_at jika ada di tabel Supabase Anda
        'created_at': DateTime.now().toIso8601String(),
        //'updated_at': DateTime.now().toIso8601String(),
      }).select('id'); // Pilih ID yang baru saja dimasukkan

      if (response != null && response.isNotEmpty) {
        return response[0]['id'] as int;
      }
      // Jika response kosong atau null setelah insert, artinya insert tidak berhasil
      print('Insert Rekam Medis: Response was null or empty after insert.');
      return null;
    } catch (e) {
      // Tangkap dan cetak error secara detail
      print('Error inserting rekam medis: $e');
      return null;
    }
  }

  // Fungsi untuk mendapatkan daftar obat
  Future<List<Map<String, dynamic>>> getObatList() async {
    try {
      final response = await _supabase.from('obat').select('id, nama, stok');
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error fetching obat list: $e');
      return [];
    }
  }
  // rekam medis berdasarkan kunjungan id
  Future<int?> getRekamMedisIdByKunjunganId(int kunjunganId) async {
    try {
      // Mencari satu record yang sesuai dengan kunjungan_id
      final response = await _supabase
          .from('rekam_medis')
          .select('id')
          .eq('kunjungan_id', kunjunganId)
          .limit(1);

      if (response != null && response.isNotEmpty) {
        return response[0]['id'] as int;
      }
      return null;
    } catch (e) {
      print('Error getting rekam medis by kunjungan ID: $e');
      return null;
    }
  }
  // Fungsi untuk mengupdate rekam_medis_obat dan mengurangi stok obat
  Future<bool> updateRekamMedisAndObatStok({
    required int rekamMedisId,
    required List<Map<String, dynamic>> selectedObatList, // [{'obat_id': ..., 'jumlah_digunakan': ...}]
  }) async {
    try {
      for (var item in selectedObatList) {
        final int obatId = item['obat_id'];
        final int jumlahDigunakan = item['jumlah_digunakan'];

        // 1. Masukkan ke rekam_medis_obat
        await _supabase.from('rekam_medis_obat').insert({
          'rekam_medis_id': rekamMedisId,
          'obat_id': obatId,
          'jumlah_digunakan': jumlahDigunakan,
          'created_at': DateTime.now().toIso8601String(),

        });

        // 2. Kurangi stok di tabel obat
        // Ambil stok saat ini
        final List<Map<String, dynamic>> currentObatResponse = await _supabase.from('obat').select('stok').eq('id', obatId);
        if (currentObatResponse.isEmpty) {
          throw Exception('Obat dengan ID $obatId tidak ditemukan.');
        }
        final int currentStok = currentObatResponse[0]['stok'] as int;
        final int newStok = currentStok - jumlahDigunakan;

        if (newStok < 0) {
          throw Exception('Stok obat tidak mencukupi untuk obat dengan ID $obatId. Stok saat ini: $currentStok, Dibutuhkan: $jumlahDigunakan');
        }

        await _supabase.from('obat').update({'stok': newStok}).eq('id', obatId);
      }
      return true;
    } catch (e) {
      print('Error updating rekam medis and obat stok: $e');
      return false;
    }
  }
}
