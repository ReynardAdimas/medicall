class Kunjungan {
  int? id;
  DateTime tanggalKunjungan;
  String keluhan;
  int idPasien;
  bool statusDiterima;
  String statusKunjungan;

  Kunjungan({
   this.id,
   required this.keluhan,
   required this.tanggalKunjungan,
   required this.statusKunjungan,
    required this.statusDiterima,
    required this.idPasien
});

  factory Kunjungan.fromMap(Map<String, dynamic> map) {
    return Kunjungan(
        id: map['id'],
        keluhan: map['keluhan'],
        tanggalKunjungan: DateTime.parse(map['tanggal_kunjungan']),
        statusKunjungan: map['status_kunjungan'],
        statusDiterima: map['status_diterima'],
        idPasien: map['id_pasien']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tanggal_kunjungan' : tanggalKunjungan.toIso8601String(),
      'keluhan' : keluhan,
      'id_pasien' : idPasien,
      'status_diterima' : statusDiterima,
      'status_kunjungan' : statusKunjungan
    };
  }
}