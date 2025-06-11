import 'package:flutter/material.dart';

class HitungBmi extends StatefulWidget {
  const HitungBmi({super.key});

  @override
  State<HitungBmi> createState() => _HitungBmiState();
}

class _HitungBmiState extends State<HitungBmi> {
  // To manage the state of the selected gender
  String? _selectedGender; // Can be 'Laki-laki' or 'Perempuan'

  // Text editing controllers for input fields
  final TextEditingController _usiaController = TextEditingController();
  final TextEditingController _tinggiBadanController = TextEditingController();
  final TextEditingController _beratBadanController = TextEditingController();

  @override
  void dispose() {
    _usiaController.dispose();
    _tinggiBadanController.dispose();
    _beratBadanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Hitung BMI'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Description
            const Text(
              'Hitung BMI (IMT)',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Matching the green in the image
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hitung BMI digunakan untuk menghitung Indeks Massa Tubuh (IMT) dan mengecek seberapa ideal berat badanmu. Kamu juga bisa pakai kalkulator ini untuk cek IMT anak.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 30),

            // Gender Selection
            Row(
              children: [
                Expanded(
                  child: _buildGenderCard(
                    context: context,
                    label: 'Laki-laki',
                    imagePath: 'assets/lakiLaki.png', // Replace with your male avatar image
                    isSelected: _selectedGender == 'Laki-laki',
                    onTap: () {
                      setState(() {
                        _selectedGender = 'Laki-laki';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGenderCard(
                    context: context,
                    label: 'Perempuan',
                    imagePath: 'assets/Perempuan.png', // Replace with your female avatar image
                    isSelected: _selectedGender == 'Perempuan',
                    onTap: () {
                      setState(() {
                        _selectedGender = 'Perempuan';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Usia (Age) Input
            _buildInputField(
              controller: _usiaController,
              labelText: 'Usia',
              hintText: 'ketik disini',
              suffixText: 'Thn',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Tinggi Badan (Height) Input
            _buildInputField(
              controller: _tinggiBadanController,
              labelText: 'Tinggi Badan',
              hintText: 'ketik disini',
              suffixText: 'Cm',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Berat Badan (Weight) Input
            _buildInputField(
              controller: _beratBadanController,
              labelText: 'Berat Badan',
              hintText: 'ketik disini',
              suffixText: 'Kg',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),

            // Hitung (Calculate) Button
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement BMI calculation logic here
                    _calculateBMI();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Hitung',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Text color
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

  // Helper widget for gender selection cards
  Widget _buildGenderCard({
    required BuildContext context,
    required String label,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: isSelected ? 4 : 1, // Higher elevation if selected
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isSelected
              ? const BorderSide(color: Colors.lightGreen, width: 2) // Green border if selected
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            children: [
              // Placeholder for image. Replace with actual Image.asset or NetworkImage
              // Example: Image.asset(imagePath, height: 60, width: 60),
              // Container(
              //   height: 60,
              //   width: 60,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Colors.grey[200], // Placeholder background
              //   ),
              //   child: Icon(
              //     label == 'Laki-laki' ? Icons.person : Icons.person_2,
              //     size: 40,
              //     color: Colors.grey[600],
              //   ),
              // ),
              Image.asset(
                imagePath,
                height: 60,
                width: 60,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.lightGreen : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for text input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required String suffixText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 8.0),
              child: Text(
                suffixText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          ),
        ),
      ],
    );
  }

  // Example BMI calculation (you'll implement the actual logic)
  void _calculateBMI() {
    double? age = double.tryParse(_usiaController.text);
    double? heightCm = double.tryParse(_tinggiBadanController.text);
    double? weightKg = double.tryParse(_beratBadanController.text);

    if (age == null || heightCm == null || weightKg == null || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data dan pilih jenis kelamin.')),
      );
      return;
    }

    // Basic BMI calculation: weight (kg) / (height (m))^2
    double heightM = heightCm / 100;
    double bmi = weightKg / (heightM * heightM);

    // For demonstration, just print. In a real app, you'd navigate to a results screen or show a dialog.
    print('Gender: $_selectedGender');
    print('Usia: $age Thn');
    print('Tinggi Badan: $heightCm Cm');
    print('Berat Badan: $weightKg Kg');
    print('BMI: ${bmi.toStringAsFixed(2)}'); // Display BMI with 2 decimal places

    String bmiCategory;
    if (bmi < 18.5) {
      bmiCategory = 'Berat Badan Kurang';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      bmiCategory = 'Berat Badan Normal';
    } else if (bmi >= 25 && bmi < 29.9) {
      bmiCategory = 'Berat Badan Berlebih (Pre-obesitas)';
    } else {
      bmiCategory = 'Obesitas';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hasil Perhitungan BMI'),
          content: Text('BMI Anda adalah: ${bmi.toStringAsFixed(2)}\nKategori: $bmiCategory'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}