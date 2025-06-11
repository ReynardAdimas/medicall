
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