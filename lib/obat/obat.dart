// class Obat {
//   int? id;
//   String nama;
//   int stok;
//
//   Obat({
//     this.id,
//     required this.nama,
//     required this.stok
//   });
//
//   // map --> note
//   factory Obat.fromMap(Map<String, dynamic> map) {
//     return Obat(
//       id: map['id'] as int,
//       nama: map['nama'] as String,
//       stok: map['stok'] as int
//     );
//   }
//   // note --> map
//   Map<String, dynamic> toMap() {
//     return {
//       'nama' : nama,
//       'stok' : stok
//     };
//   }
// }
// lib/obat/obat.dart
class Obat {
  final int? id; // Make ID nullable for new entries (auto-incremented by DB)
  final String nama;
  final int stok;

  Obat({this.id, required this.nama, required this.stok});

  // Factory constructor to create an Obat object from a Map (Supabase response)
  factory Obat.fromMap(Map<String, dynamic> map) {
    return Obat(
      id: map['id'] as int?, // Cast to int?
      nama: map['nama'] as String,
      stok: map['stok'] as int,
    );
  }

  // Method to convert an Obat object to a Map (for Supabase insert/update)
  Map<String, dynamic> toMap() {
    return {
      // 'id': id, // Don't include ID for inserts if it's auto-incrementing
      'nama': nama,
      'stok': stok,
    };
  }
}