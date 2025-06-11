// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For date formatting
//
// class MasaSuburResultScreen extends StatelessWidget {
//   final DateTime menstruasiStart;
//   final DateTime menstruasiEnd;
//   final DateTime masaSuburStart;
//   final DateTime masaSuburEnd;
//   final DateTime ovulasiDate;
//
//   const MasaSuburResultScreen({
//     super.key,
//     required this.menstruasiStart,
//     required this.menstruasiEnd,
//     required this.masaSuburStart,
//     required this.masaSuburEnd,
//     required this.ovulasiDate,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Date formatter for ranges
//     final DateFormat formatter = DateFormat('dd MMMM');
//     final DateFormat fullFormatter = DateFormat('dd MMMM yyyy'); // For full dates
//
//     String formatRange(DateTime start, DateTime end) {
//       if (start.year == end.year && start.month == end.month) {
//         return '${formatter.format(start)} - ${formatter.format(end)}';
//       } else if (start.year == end.year) {
//         return '${formatter.format(start)} - ${formatter.format(end)}';
//       } else {
//         return '${fullFormatter.format(start)} - ${fullFormatter.format(end)}';
//       }
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text('Hasil'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Tanggal Subur Card
//             const Center(
//               child: Text(
//                 'Tanggal Subur',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green, // Matching the green in the image
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildResultRow(
//                       label: 'Menstruasi',
//                       value: formatRange(menstruasiStart, menstruasiEnd),
//                       labelColor: Colors.red,
//                     ),
//                     const SizedBox(height: 10),
//                     _buildResultRow(
//                       label: 'Masa Subur',
//                       value: formatRange(masaSuburStart, masaSuburEnd),
//                       labelColor: Colors.blue,
//                     ),
//                     const SizedBox(height: 10),
//                     _buildResultRow(
//                       label: 'Ovulasi',
//                       value: formatter.format(ovulasiDate),
//                       labelColor: Colors.blue,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//
//             // Disclaimer Card
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               color: Colors.grey.shade50, // Lighter background for disclaimer
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [
//                         Icon(Icons.info_outline, color: Colors.black54, size: 20),
//                         SizedBox(width: 8),
//                         Text(
//                           'Disclaimer',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       'Kalkulator ini bukanlah sebuah alat diagnosis medis ataupun pengganti konsultasi dokter spesialis kandungan dan kesuburan. Alat ini hanya untuk prediksi masa subur yang bisa Anda lakukan mandiri, sebaiknya tetap konsultasi ke dokter agar tahu lebih pasti kondisi kesehatan Anda saat ini.',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//
//             // Hitung Ulang Button
//             Center(
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Go back to the calculator screen
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.lightGreen,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                   child: const Text(
//                     'Hitung Ulang',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper widget for a single result row
//   Widget _buildResultRow({
//     required String label,
//     required String value,
//     Color labelColor = Colors.black, // Default color for label
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: labelColor,
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[800],
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class MasaSuburResultScreen extends StatelessWidget {
  final DateTime menstruasiStart;
  final DateTime menstruasiEnd;
  final DateTime masaSuburStart;
  final DateTime masaSuburEnd;
  final DateTime ovulasiDate;
  final DateTime estimatedDueDate; // Added for HPL

  const MasaSuburResultScreen({
    super.key,
    required this.menstruasiStart,
    required this.menstruasiEnd,
    required this.masaSuburStart,
    required this.masaSuburEnd,
    required this.ovulasiDate,
    required this.estimatedDueDate, // Required HPL
  });

  @override
  Widget build(BuildContext context) {
    // Date formatter for ranges
    final DateFormat formatter = DateFormat('dd MMMM');
    final DateFormat fullFormatter = DateFormat('dd MMMM yyyy'); // For full dates

    String formatRange(DateTime start, DateTime end) {
      if (start.year == end.year && start.month == end.month) {
        return '${formatter.format(start)} - ${formatter.format(end)}';
      } else if (start.year == end.year) {
        return '${formatter.format(start)} - ${formatter.format(end)}';
      } else {
        return '${fullFormatter.format(start)} - ${fullFormatter.format(end)}';
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Hasil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tanggal Subur Card
            const Center(
              child: Text(
                'Tanggal Subur & Perkiraan Lahir', // Updated title
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Matching the green in the image
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResultRow(
                      label: 'Menstruasi',
                      value: formatRange(menstruasiStart, menstruasiEnd),
                      labelColor: Colors.red,
                    ),
                    const SizedBox(height: 10),
                    _buildResultRow(
                      label: 'Masa Subur',
                      value: formatRange(masaSuburStart, masaSuburEnd),
                      labelColor: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    _buildResultRow(
                      label: 'Ovulasi',
                      value: formatter.format(ovulasiDate),
                      labelColor: Colors.blue,
                    ),
                    const SizedBox(height: 20), // Add some space
                    // Display HPL
                    _buildResultRow(
                      label: 'Hari Perkiraan Lahir (HPL)',
                      value: fullFormatter.format(estimatedDueDate),
                      labelColor: Colors.purple, // A distinct color for HPL
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Disclaimer Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.grey.shade50, // Lighter background for disclaimer
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.black54, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Disclaimer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kalkulator ini bukanlah sebuah alat diagnosis medis ataupun pengganti konsultasi dokter spesialis kandungan dan kesuburan. Alat ini hanya untuk prediksi masa subur dan perkiraan tanggal lahir yang bisa Anda lakukan mandiri, sebaiknya tetap konsultasi ke dokter agar tahu lebih pasti kondisi kesehatan Anda saat ini.', // Updated disclaimer
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Hitung Ulang Button
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the calculator screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Hitung Ulang',
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

  // Helper widget for a single result row
  Widget _buildResultRow({
    required String label,
    required String value,
    Color labelColor = Colors.black, // Default color for label
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}