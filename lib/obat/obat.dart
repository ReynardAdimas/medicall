class Obat {
  int? id;
  String nama;
  int stok;

  Obat({
    this.id,
    required this.nama,
    required this.stok
  });

  // map --> note
  factory Obat.fromMap(Map<String, dynamic> map) {
    return Obat(
      id: map['id'] as int,
      nama: map['nama'] as String,
      stok: map['stok'] as int
    );
  }
  // note --> map
  Map<String, dynamic> toMap() {
    return {
      'nama' : nama,
      'stok' : stok
    };
  }
}