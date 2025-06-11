// class KunjunganDetailPasien {
//   final int id;
//   final DateTime tanggalKunjungan;
//   final String? namaPasien; // <-- Ubah menjadi nullable
//   final String? keluhan;    // <-- Ubah menjadi nullable
//
//   KunjunganDetailPasien({
//     required this.id,
//     required this.tanggalKunjungan,
//     required this.namaPasien,
//     required this.keluhan,
//   });
//
//   factory KunjunganDetailPasien.fromMap(Map<String, dynamic> map) {
//     return KunjunganDetailPasien(
//       id: map['id'],
//       tanggalKunjungan: DateTime.parse(map['tanggal_kunjungan']),
//       // Gunakan operator null-aware ?. untuk mengakses 'nama' dari 'id_pasien'
//       // dan pastikan hasil cast ke String?
//       namaPasien: map['id_pasien']?['nama'] as String?,
//       // Pastikan hasil cast ke String?
//       keluhan: map['keluhan'] as String?,
//     );
//   }
// }
// lib/models/kunjungan_detail_pasien.dart
class KunjunganDetailPasien {
  final int id;
  final DateTime tanggalKunjungan;
  final String keluhan;
  final String namaPasien;
  final String statusKunjungan;
  final bool statusDiterima;

  KunjunganDetailPasien({
    required this.id,
    required this.tanggalKunjungan,
    required this.keluhan,
    required this.namaPasien,
    required this.statusKunjungan,
    required this.statusDiterima,
  });

  factory KunjunganDetailPasien.fromMap(Map<String, dynamic> map) {
    // Memastikan parsing nama pasien dari nested map 'pasien'
    final String retrievedNamaPasien = map['pasien'] != null && map['pasien']['nama'] != null
        ? map['pasien']['nama'] as String
        : 'Nama Tidak Ditemukan'; // Fallback jika nama pasien tidak ada

    return KunjunganDetailPasien(
      id: map['id'] as int,
      tanggalKunjungan: DateTime.parse(map['tanggal_kunjungan'] as String),
      keluhan: map['keluhan'] as String,
      namaPasien: retrievedNamaPasien,
      statusKunjungan: map['status_kunjungan'] as String,
      statusDiterima: map['status_diterima'] as bool,
    );
  }
}