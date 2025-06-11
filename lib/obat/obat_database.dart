import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaaaa/obat/obat.dart';

class ObatDatabase {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Method to create a new medicine entry
  Future<void> createObat(Obat obat) async {
    try {
      await _supabase.from('obat').insert(obat.toMap());
    } catch (e) {
      print('Error creating obat: $e');
      rethrow;
    }
  }

  // Method to update an existing medicine entry by its ID
  Future<void> updateObat(int id, Map<String, dynamic> fieldsToUpdate) async {
    try {
      await _supabase.from('obat').update(fieldsToUpdate).eq('id', id);
    } catch (e) {
      print('Error updating obat: $e');
      rethrow;
    }
  }

  // Get a medicine by its name
  Future<Obat?> getObatByName(String nama) async {
    try {
      final response = await _supabase
          .from('obat')
          .select()
          .eq('nama', nama)
          .maybeSingle(); // maybeSingle returns null if no record found, or a single map if found

      if (response != null) {
        return Obat.fromMap(response);
      }
      return null;
    } catch (e) {
      print('Error getting obat by name: $e');
      return null; // Return null if an error occurs or no obat found
    }
  }

  // Method to get all medicines for display (one-time fetch)
  Future<List<Obat>> getAllObat() async {
    try {
      final response = await _supabase.from('obat').select().order('nama', ascending: true);
      return (response as List).map((map) => Obat.fromMap(map as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting all obat: $e');
      return [];
    }
  }

  // NEW: Stream for real-time updates of all medicine entries
  Stream<List<Obat>> getObatStream() {
    // 'id' is used as primaryKey to enable real-time updates from Supabase
    return _supabase.from('obat').stream(primaryKey: ['id']).order('nama', ascending: true).map((data) {
      return data.map((map) => Obat.fromMap(map)).toList();
    });
  }
}