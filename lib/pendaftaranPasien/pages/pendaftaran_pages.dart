import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supaaaa/pendaftaranPasien/kunjungan.dart';
import 'package:supaaaa/pendaftaranPasien/kunjungan_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PendaftaranPages extends StatefulWidget {
  const PendaftaranPages({super.key});

  @override
  State<PendaftaranPages> createState() => _PendaftaranPagesState();
}

class _PendaftaranPagesState extends State<PendaftaranPages> {
  final TextEditingController _keluhanController = TextEditingController();
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _keluhanController.dispose();
    super.dispose();
  }

  // Fungsi untuk mendapatkan hari-hari dalam sebulan untuk tampilan kalender
  List<DateTime?> _getDaysInMonth(DateTime month) {
    List<DateTime?> days = [];
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    // Menyesuaikan Sunday = 0, Monday = 1, ..., Saturday = 6
    int firstDayOfWeek = firstDayOfMonth.weekday; // Monday is 1, Sunday is 7 in Dart's weekday.
    if (firstDayOfWeek == 7) {
      firstDayOfWeek = 0; // If it's Sunday (7), make it 0
    }

    // Tambahkan null untuk hari-hari dari bulan sebelumnya
    for (int i = 0; i < firstDayOfWeek; i++) {
      days.add(null);
    }

    // Tambahkan hari-hari dalam bulan ini
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    // Tambahkan null untuk hari-hari dari bulan berikutnya
    // Pastikan total sel adalah kelipatan 7 dan minimal 5 baris (35 hari)
    while (days.length % 7 != 0 || days.length < 35) {
      days.add(null);
    }

    return days;
  }

  // Fungsi untuk berpindah ke bulan sebelumnya
  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  // Fungsi untuk berpindah ke bulan berikutnya
  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  // Fungsi yang dipanggil saat tanggal di kalender ditekan
  void _onDaySelected(DateTime day) {
    setState(() {
      _selectedDate = day;
      // Opsional: Pindah ke bulan yang dipilih jika tanggalnya di bulan lain
      if (day.month != _currentMonth.month || day.year != _currentMonth.year) {
        _currentMonth = DateTime(day.year, day.month, 1);
      }
    });
    print('Tanggal dipilih dari kalender: $_selectedDate'); // Debugging
  }

  // Fungsi untuk menyimpan pendaftaran (contoh, sesuaikan dengan KunjunganDatabase Anda)
  Future<void> savePendaftaran() async {
    if(_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tanggal kunjungan harus diisi!"))
      );
      return;
    }
    final tanggalKunjungan = _selectedDate;
    final keluhan = _keluhanController.text;
    try {
      await KunjunganDatabase().tambahKunjungan(
        tanggalKunjungan: tanggalKunjungan,
        keluhan: keluhan,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran Berhasil'))
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error saat menyimpan pendaftaran: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi Kesalahan: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime?> daysInView = _getDaysInMonth(_currentMonth);
    final String monthYear = DateFormat('MMMM', 'id_ID').format(_currentMonth);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Pendaftaran'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Header (dynamic month and year)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: _goToPreviousMonth,
                ),
                Text(
                  monthYear,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _goToNextMonth,
                ),
              ],
            ),
            // Opsional: Tampilkan tanggal yang dipilih di sini
            if (_selectedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    'Tanggal dipilih: ${DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_selectedDate!)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            const SizedBox(height: 20), // Sesuaikan spasi jika menampilkan tanggal pilihan

            // Weekday Headers
            Table(
              children: [
                TableRow(
                  children: [
                    _buildDayHeader('MIN'), // Sunday
                    _buildDayHeader('SEN'), // Monday
                    _buildDayHeader('SEL'), // Tuesday
                    _buildDayHeader('RAB'), // Wednesday
                    _buildDayHeader('KAM'), // Thursday
                    _buildDayHeader('JUM'), // Friday
                    _buildDayHeader('SAB'), // Saturday
                  ],
                ),
              ],
            ),
            // Calendar Days (dynamic & tappable)
            Table(
              border: TableBorder.all(color: Colors.transparent),
              children: List.generate((daysInView.length / 7).ceil(), (rowIndex) {
                return TableRow(
                  children: List.generate(7, (colIndex) {
                    final dayIndex = rowIndex * 7 + colIndex;
                    if (dayIndex < daysInView.length && daysInView[dayIndex] != null) {
                      final day = daysInView[dayIndex]!;
                      final isCurrentMonth = day.month == _currentMonth.month && day.year == _currentMonth.year;
                      final isSelected = _selectedDate != null &&
                          _selectedDate!.year == day.year &&
                          _selectedDate!.month == day.month &&
                          _selectedDate!.day == day.day;

                      return _buildDayCell(
                        day.day.toString(),
                        isPreviousMonth: !isCurrentMonth && day.isBefore(DateTime(_currentMonth.year, _currentMonth.month, 1)),
                        isNextMonth: !isCurrentMonth && day.isAfter(DateTime(_currentMonth.year, _currentMonth.month + 1, 0)),
                        onTap: () => _onDaySelected(day), // Tangkap tap di sini
                        isSelected: isSelected, // Kirim status terpilih
                      );
                    } else {
                      return _buildDayCell('', onTap: null); // Sel kosong tidak bisa ditekan
                    }
                  }),
                );
              }),
            ),
            const SizedBox(height: 30),

            // Keluhan (Complaint) Section
            const Text(
              'Keluhan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: _keluhanController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'ketik disini',
                  contentPadding: EdgeInsets.all(12.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Simpan Button
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: savePendaftaran, // Uncomment dan gunakan fungsi savePendaftaran Anda
                  // onPressed: () {
                  //   if (_selectedDate == null) {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(content: Text("Tanggal kunjungan harus diisi!"))
                  //     );
                  //   } else {
                  //     print('Tanggal Dipilih: ${_selectedDate}');
                  //     print('Keluhan: ${_keluhanController.text}');
                  //     // Lanjutkan dengan logika penyimpanan Anda di sini
                  //     // Anda bisa langsung menggunakan _selectedDate dan _keluhanController.text
                  //   }
                  // },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for weekday headers
  static Widget _buildDayHeader(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  // Helper widget for calendar day cells - NOW TAPPABLE
  Widget _buildDayCell(String day,
      {bool isPreviousMonth = false,
        bool isNextMonth = false,
        VoidCallback? onTap, // Tambahkan callback untuk tap
        bool isSelected = false // Tambahkan status terpilih
      }) {
    Color textColor = Colors.black;
    if (isPreviousMonth || isNextMonth) {
      textColor = Colors.grey;
    }

    // Warna latar belakang jika tanggal dipilih
    Color? backgroundColor = Colors.transparent;
    if (isSelected) {
      backgroundColor = Colors.lightGreen.shade200; // Warna latar belakang saat dipilih
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle, // Bentuk lingkaran untuk sel yang dipilih
        ),
        child: Text(
          day,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}