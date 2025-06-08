import 'package:flutter/material.dart';
import 'riwayatKunjungan2.dart';

class Riwayatkunjungan1 extends StatefulWidget {
  const Riwayatkunjungan1({super.key});

  @override
  State<Riwayatkunjungan1> createState() => _Riwayatkunjungan1State();
}

class _Riwayatkunjungan1State extends State<Riwayatkunjungan1> {
  final List<String> _patientNames = [
    'Dika',
    'Budi Santoso',
    'Citra Dewi',
    'Dewi Sartika',
    'Eko Prasetyo',
    'Fara Adiba',
    'Gani Wijaya',
    'Hana Lestari',
    'Iman Jaya',
    'Joko Susanto',
  ];

  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  // Filtered list of patient names based on search query
  List<String> _filteredPatientNames = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with all patient names
    _filteredPatientNames = _patientNames;
    // Add listener to search controller to filter patients
    _searchController.addListener(_filterPatients);
  }

  @override
  void dispose() {
    // Dispose the search controller when the widget is removed from the tree
    _searchController.removeListener(_filterPatients);
    _searchController.dispose();
    super.dispose();
  }

  // Method to filter patient names based on search input
  void _filterPatients() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatientNames = _patientNames
          .where((patient) => patient.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Handle back button press, e.g., navigate back
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Daftar Kunjungan Pasien'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'cari nama pasien',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none, // No border line
                ),
                filled: true,
                fillColor: Colors.grey[200], // Background color for the search bar
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ),
          ),
          // Header for the list of names
          Container(
            color: Colors.grey[100], // Light grey background
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Nama',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPatientNames.length,
              itemBuilder: (context, index) {
                final patientName = _filteredPatientNames[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigate to RiwayatKunjungan2 and pass the patient's name
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RiwayatKunjungan2(patientName: patientName),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                patientName,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    // Add a thin divider below each item for visual separation
                    Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}