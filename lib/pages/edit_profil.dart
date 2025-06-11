import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileFieldScreen extends StatefulWidget {
  final String currentFieldValue;
  final String fieldLabel; // Contoh: "Umur", "Pekerjaan", "Alamat"
  final String columnName; // Nama kolom di Supabase: "umur", "pekerjaan", "alamat"
  final String userUuid;
  final TextInputType keyboardType;

  const EditProfileFieldScreen({
    super.key,
    required this.currentFieldValue,
    required this.fieldLabel,
    required this.columnName,
    required this.userUuid,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<EditProfileFieldScreen> createState() => _EditProfileFieldScreenState();
}

class _EditProfileFieldScreenState extends State<EditProfileFieldScreen> {
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentFieldValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updateField() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final newValue = _controller.text.trim();

      // Konversi nilai ke tipe yang sesuai jika diperlukan (misal: int untuk umur)
      dynamic valueToSave = newValue;
      if (widget.columnName == 'umur') {
        valueToSave = int.tryParse(newValue);
        if (valueToSave == null && newValue.isNotEmpty) { // Izinkan string kosong untuk reset
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Umur harus berupa angka.')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      await supabase.from('pasien').update({
        widget.columnName: valueToSave,
      }).eq('user_id', widget.userUuid);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.fieldLabel} berhasil diperbarui.')),
      );
      Navigator.pop(context, true); // Indikasikan sukses
    } catch (e) {
      print('Error updating ${widget.fieldLabel}: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui ${widget.fieldLabel}: ${e.toString()}')),
      );
      Navigator.pop(context, false); // Indikasikan gagal
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah ${widget.fieldLabel}'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                labelText: widget.fieldLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _updateField,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}