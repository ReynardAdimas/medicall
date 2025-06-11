import 'package:flutter/material.dart';

class Imunisasi extends StatefulWidget {
  const Imunisasi({super.key});

  @override
  State<Imunisasi> createState() => _ImunisasiState();
}

class _ImunisasiState extends State<Imunisasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Imunisasi',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with Medical Theme
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.green.shade50, // Light blue background
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green,
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                gradient: LinearGradient(
                  colors: [Colors.green.shade50, Colors.lightGreen.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.vaccines, // Medical icon for vaccines
                    size: 40,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'Informasi Vaksin Anak',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey, // A professional blue-grey
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Vaksin Information Cards
            _buildVaksinCard(
              title: 'BCG',
              details: [
                'Untuk usia: 1-3 bulan',
                'Jumlah dosis: 1x',
                'Untuk penyakit: TBC (Tuberculosis)',
                'Informasi tambahan: Jika diberikan pada usia di atas 3 bulan, anak harus menjalani Tes Mantoux',
              ],
              icon: Icons.baby_changing_station, // Icon related to baby
            ),
            const SizedBox(height: 15),
            _buildVaksinCard(
              title: 'Hepatitis B',
              details: [
                'Untuk usia: mulai 0 bulan',
                'Jumlah dosis: 3x',
                'Untuk penyakit: Hepatitis B',
                'Informasi tambahan: Sebagai vaksin tunggal diberikan di usia 0, 1 dan 6 bulan, sedangkan jika sebagai vaksin kombinasi mengikuti jenis vaksin yang lain.',
              ],
              icon: Icons.medical_services_outlined, // General medical icon
            ),
            const SizedBox(height: 15),
            _buildVaksinCard(
              title: 'Polio',
              details: [
                'Untuk usia: 0 bulan-6 tahun',
                'Jumlah dosis: 4-5x',
                'Untuk penyakit: Polio',
                'Informasi tambahan: Vaksin Polio anak dapat diberikan melalui suntikan (IPV) atau secara oral (OPV)',
              ],
              icon: Icons.accessibility_new, // Icon for movement/limbs
            ),
            const SizedBox(height: 15),
            _buildVaksinCard(
              title: 'DTP-Hib',
              details: [
                'Untuk usia: 2 bulan-5 tahun',
                'Jumlah dosis: 3x',
                'Untuk penyakit: Difteri, Tetanus, Pertusis (Batuk Rejan), Hib (Haemophilus influenzae tipe b)',
              ],
              icon: Icons.sick, // Icon related to sickness
            ),
            const SizedBox(height: 15),
            // Add more _buildVaksinCard widgets for other vaccines as needed
          ],
        ),
      ),
    );
  }

  // Helper widget to build a single vaksin information card
  Widget _buildVaksinCard({
    required String title,
    required List<String> details,
    required IconData icon, // Icon for the card
  }) {
    return Card(
      elevation: 4, // Add more elevation for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Slightly more rounded corners
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: Colors.blue.shade700), // Larger, darker icon
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800, // Stronger blue for title
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 25, thickness: 1, color: Colors.black12), // Subtle divider

            // Details as bullet points
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details.map((detail) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Icon(Icons.circle, size: 8, color: Colors.green.shade600), // Green bullet points
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          detail,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade800,
                            height: 1.4, // Line height for readability
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
