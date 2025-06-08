import 'package:flutter/material.dart';

class Diagnosispage2 extends StatefulWidget {
  const Diagnosispage2({super.key});

  @override
  State<Diagnosispage2> createState() => _Diagnosispage2State();
}

class _Diagnosispage2State extends State<Diagnosispage2> {
  final TextEditingController _jumlahObatDibutuhkanController =
  TextEditingController();
  int _numberOfMedicineFields = 0;

  // This list will hold the selected medicine for each dropdown
  List<String?> _selectedMedicines = [];
  // This list will hold the quantity for each medicine input field
  List<TextEditingController> _jumlahObatControllers = [];

  // Dummy list of medicines for the dropdown
  final List<String> _medicineOptions = [
    'Paracetamol',
    'Amoxicillin',
    'Ibuprofen',
    'Vitamin C',
    'Antacid',
  ];

  @override
  void initState() {
    super.initState();
    // Add a listener to the controller to update medicine fields dynamically
    _jumlahObatDibutuhkanController.addListener(_updateMedicineFields);
  }

  @override
  void dispose() {
    // Clean up controllers and listeners to prevent memory leaks
    _jumlahObatDibutuhkanController.removeListener(_updateMedicineFields);
    _jumlahObatDibutuhkanController.dispose();
    for (var controller in _jumlahObatControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Method to update the number of dynamically generated medicine input fields
  void _updateMedicineFields() {
    int? newCount = int.tryParse(_jumlahObatDibutuhkanController.text);
    if (newCount != null && newCount >= 0) {
      // If a valid non-negative number is entered
      setState(() {
        _numberOfMedicineFields = newCount;
        // Adjust the size of the selected medicines list based on the new count
        while (_selectedMedicines.length < _numberOfMedicineFields) {
          _selectedMedicines.add(null); // Add null for new dropdowns
        }
        while (_selectedMedicines.length > _numberOfMedicineFields) {
          _selectedMedicines.removeLast(); // Remove excess items
        }

        // Adjust the size of the quantity controllers list based on the new count
        while (_jumlahObatControllers.length < _numberOfMedicineFields) {
          _jumlahObatControllers.add(TextEditingController()); // Add new controllers
        }
        while (_jumlahObatControllers.length > _numberOfMedicineFields) {
          _jumlahObatControllers.last.dispose(); // Dispose and remove excess controllers
          _jumlahObatControllers.removeLast();
        }
      });
    } else if (_jumlahObatDibutuhkanController.text.isEmpty) {
      // If the input field is empty, reset the fields
      setState(() {
        _numberOfMedicineFields = 0;
        _selectedMedicines.clear(); // Clear selected medicines
        for (var controller in _jumlahObatControllers) {
          controller.dispose(); // Dispose all current controllers
        }
        _jumlahObatControllers.clear(); // Clear the list of controllers
      });
    }
  }

  // Method to handle saving the entered data
  void _saveData() {
    print('Number of medicines needed: $_numberOfMedicineFields');
    for (int i = 0; i < _numberOfMedicineFields; i++) {
      print('Medicine ${i + 1}:');
      print('  Selected Medicine: ${_selectedMedicines[i] ?? "Not selected"}');
      print('  Quantity: ${_jumlahObatControllers[i].text}');
    }
    // TODO: Implement your actual save logic here, e.g., send data to a backend or local storage
    // You might want to add validation before saving.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Handle back button press: navigate back
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Masukkan Obat'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jumlah Obat yang dibutuhkan',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _jumlahObatDibutuhkanController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'cth: 2',
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Dynamically generated medicine input fields based on _numberOfMedicineFields
                  ListView.builder(
                    shrinkWrap: true, // Allows ListView to take only required space
                    physics: const NeverScrollableScrollPhysics(), // Disables ListView's own scrolling
                    itemCount: _numberOfMedicineFields,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daftar Obat',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedMedicines[index],
                              hint: const Text('Pilih Obat'),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                              ),
                              items: _medicineOptions.map((String medicine) {
                                return DropdownMenuItem<String>(
                                  value: medicine,
                                  child: Text(medicine),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMedicines[index] = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Jumlah Obat',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _jumlahObatControllers[index],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'cth: 1',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Save button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _saveData(); // Call the save data method
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}