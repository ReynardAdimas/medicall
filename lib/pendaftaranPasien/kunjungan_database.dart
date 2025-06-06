import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaaaa/models/kunjungan_detail_pasien.dart';


class KunjunganDatabase {
  final database = Supabase.instance.client;

  Future<String?> _getPasienIdForCurrentUser() async {
    final currentUserUuid = database.auth.currentUser?.id;

    if (currentUserUuid == null) {
      print('Error: Pengguna tidak login atau UUID tidak ditemukan.');
      return null;
    }

    try {
      final response = await database
          .from('pasien')
          .select('id')
          .eq('user_id', currentUserUuid)
          .single();

      if (response != null && response['id'] != null) {
        print('ID Pasien ditemukan: ${response['id']}');
        return response['id'].toString();
      } else {
        print('Pasien tidak ditemukan untuk UUID: $currentUserUuid');
        return null;
      }
    } catch (e) {
      print('Error saat mendapatkan ID pasien: $e');
      return null;
    }
  }

  // Create
  Future<void> tambahKunjungan({
    required DateTime? tanggalKunjungan,
    required String keluhan
  }) async {
    final idPasien = await _getPasienIdForCurrentUser();

    if(idPasien == null) {
      throw Exception('Tidak dapat menemukan ID pasien terkait untuk pengguna ini. Pastikan data pasien sudah terdaftar.');
    }

    try {
      await database.from('kunjungan').insert({
        'tanggal_kunjungan' : tanggalKunjungan?.toIso8601String(),
        'keluhan' : keluhan,
        'id_pasien' : idPasien,
        'status_diterima' : false,
        'status_kunjungan' : 'waiting'
      });
    } catch (e) {
      print('Error saat menambahkan kunjungan: $e');
      rethrow;
    }
  }

  Future<List<KunjunganDetailPasien>> ambilSemuaKunjungan() async {
    try {
      final data = await database
          .from('kunjungan')
          .select('id, tanggal_kunjungan, id_pasien(nama)')
          .eq('status_kunjungan', 'waiting');
      return (data as List).map((e) => KunjunganDetailPasien.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error saat mengambil data kunjungan dan pasien: $e');
      rethrow;
    }
  }

  Future<List<KunjunganDetailPasien>> ambilKunjunganDiterima() async {
   try {
     final data = await database
         .from('kunjungan')
         .select('id, tanggal_kunjungan, keluhan, id_pasien(nama)')
         .eq('status_diterima', true);
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
}