import 'package:flutter/material.dart'; // Mungkin tidak perlu di sini, tapi tidak apa-apa
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaaaa/models/kunjungan_detail_pasien.dart'; // Pastikan path ini benar

class KunjunganDatabase {
  final database = Supabase.instance.client;

  Future<String?> _getPasienIdForCurrentUser() async {
    final currentUserUuid = database.auth.currentUser?.id;

    if (currentUserUuid == null) {
      print('Error: Pengguna tidak login atau UUID tidak ditemukan.');
      return null;
    }

    try {
      // PERBAIKAN: Ambil 'user_id' dari tabel 'pasien' karena ini adalah UUID yang kita butuhkan.
      // Asumsi kolom 'user_id' di tabel 'pasien' menyimpan UUID dari auth.users.id
      final response = await database
          .from('pasien')
          .select('user_id') // <--- UBAH DARI 'id' MENJADI 'user_id'
          .eq('user_id', currentUserUuid) // Filter berdasarkan user_id yang sedang login
          .single(); // Asumsi user_id unik di tabel pasien

      if (response != null && response['user_id'] != null) {
        // idPasien yang akan dikembalikan sekarang adalah UUID (String) yang benar
        print('User ID Pasien ditemukan: ${response['user_id']}');
        return response['user_id'].toString(); // Ini sudah UUID string
      } else {
        print('Pasien tidak ditemukan untuk UUID: $currentUserUuid di tabel pasien.');
        return null;
      }
    } catch (e) {
      print('Error saat mendapatkan user ID pasien dari tabel pasien: $e');
      return null;
    }
  }

  // Create
  Future<void> tambahKunjungan({
    required DateTime? tanggalKunjungan,
    required String keluhan
  }) async {
    // idPasienUuid di sini akan menjadi UUID (String) yang benar dari _getPasienIdForCurrentUser()
    final String? idPasienUuid = await _getPasienIdForCurrentUser();

    if(idPasienUuid == null) {
      throw Exception('Tidak dapat menemukan ID pasien terkait untuk pengguna ini. Pastikan data pasien sudah terdaftar.');
    }

    try {
      await database.from('kunjungan').insert({
        'tanggal_kunjungan' : tanggalKunjungan?.toIso8601String(),
        'keluhan' : keluhan,
        'id_pasien' : idPasienUuid, // Sekarang akan menerima UUID string yang benar
        'status_diterima' : false,
        'status_kunjungan' : 'waiting'
      });
    } catch (e) {
      print('Error saat menambahkan kunjungan: $e');
      rethrow; // Lempar ulang error agar PendaftaranPages bisa menanganinya
    }
  }

  // Read: Mengambil semua kunjungan
  Future<List<KunjunganDetailPasien>> ambilSemuaKunjungan() async {
    try {
      // PERBAIKAN: Menggunakan 'pasien(nama)' untuk join relasi ke tabel pasien
      // dan juga memilih status_kunjungan serta status_diterima
      final data = await database
          .from('kunjungan')
          .select('*, pasien(nama)') // Select semua kolom dari kunjungan, dan nama dari relasi pasien
          .eq('status_kunjungan', 'waiting'); // Anda mungkin ingin filter status di sini

      // Jika status_diterima dan status_kunjungan juga diperlukan di model,
      // pastikan mereka ada di hasil 'data' ini.
      // Asumsi '*' akan mengambil kolom status_diterima dan status_kunjungan dari kunjungan.
      return (data as List).map((e) => KunjunganDetailPasien.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error saat mengambil data kunjungan dan pasien: $e');
      rethrow;
    }
  }

  // Read: Mengambil kunjungan yang Diterima
  Future<List<KunjunganDetailPasien>> ambilKunjunganDiterima() async {
    try {
      // PERBAIKAN: Menggunakan 'pasien(nama)' untuk join relasi ke tabel pasien
      // dan juga memilih status_kunjungan serta status_diterima
      final data = await database
          .from('kunjungan')
          .select('*, pasien(nama)') // Select semua kolom dari kunjungan, dan nama dari relasi pasien
          .eq('status_diterima', true); // Anda mungkin ingin filter status di sini

      // Asumsi '*' akan mengambil kolom status_kunjungan dan status_diterima dari kunjungan.
      return (data as List).map((e) => KunjunganDetailPasien.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error saat mengambil data kunjungan dan pasien: $e');
      rethrow;
    }
  }

  // Update
  Future<void> updateKunjungan(int id, Map<String, dynamic> fieldToUpdate) async {
    await database.from('kunjungan').update(fieldToUpdate).eq('id', id);
  }

  Future<List<KunjunganDetailPasien>> ambilKunjunganBelumDiperiksa() async {
    try{
      final List<Map<String, dynamic>> rekamMedisKunjunganIds = await database.from('rekam_medis').select('kunjungan_id');
      final List<int> existingRekamMedisKunjunganIds = rekamMedisKunjunganIds.map((e) => e['kunjungan_id'] as int).toList();
      final response = await database.from('kunjungan').select('*, pasien(*)').eq('status_diterima', true).not('id','in', existingRekamMedisKunjunganIds.isEmpty?[-1] : existingRekamMedisKunjunganIds).order('tanggal_kunjungan', ascending: true);
      if(response != null && response is List) {
        return response.map((item) => KunjunganDetailPasien.fromMap(item as Map<String, dynamic>)).toList();

      }
      return [];
    } catch (e) {
      print('Error saat mengambil data kunjungan dan pasien: $e');
      return [];
    }
  }
}