import 'package:supabase_flutter/supabase_flutter.dart';

import 'obat.dart';

class ObatDatabase {
  // Database --> obat
  final database = Supabase.instance.client.from('obat');

  // Create
  Future createObat(Obat newObat) async {
    await database.insert(newObat.toMap());
  }
  // Read
  final stream = Supabase.instance.client.from('obat').stream(primaryKey: ['id']
  ).map((data) => data.map((obatMap) => Obat.fromMap(obatMap)).toList());

  // Update
  Future updateObat(Obat oldObat, String newNama, int newStok) async {
    await database.update(
      {
        'nama' : newNama,
        'stok' : newStok
      }
    ).eq('id', oldObat.id!);
  }

  // Delete
  Future deleteObat(Obat obat) async {
    await database.delete().eq('id', obat.id!);
  }
}