class KunjunganDetailPasien {
  final int id;
  final DateTime tanggalKunjungan;
  final String? namaPasien; // <-- Ubah menjadi nullable
  final String? keluhan;    // <-- Ubah menjadi nullable

  KunjunganDetailPasien({
    required this.id,
    required this.tanggalKunjungan,
    required this.namaPasien,
    required this.keluhan,
  });

  factory KunjunganDetailPasien.fromMap(Map<String, dynamic> map) {
    return KunjunganDetailPasien(
      id: map['id'],
      tanggalKunjungan: DateTime.parse(map['tanggal_kunjungan']),
      // Gunakan operator null-aware ?. untuk mengakses 'nama' dari 'id_pasien'
      // dan pastikan hasil cast ke String?
      namaPasien: map['id_pasien']?['nama'] as String?,
      // Pastikan hasil cast ke String?
      keluhan: map['keluhan'] as String?,
    );
  }
}
