// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For date formatting
// import 'masa_subur.dart'; // Import the new result screen
//
// class HitungHpl extends StatefulWidget {
//   const HitungHpl({super.key});
//
//   @override
//   State<HitungHpl> createState() => _HitungHplState();
// }
//
// class _HitungHplState extends State<HitungHpl> {
//   // Text editing controllers for input fields
//   final TextEditingController _hphtController = TextEditingController();
//   final TextEditingController _siklusMensController = TextEditingController();
//   final TextEditingController _lamaMensController = TextEditingController();
//
//   // State to hold the selected date for HPHT
//   DateTime? _selectedHphtDate;
//
//   @override
//   void dispose() {
//     _hphtController.dispose();
//     _siklusMensController.dispose();
//     _lamaMensController.dispose();
//     super.dispose();
//   }
//
//   // Function to show the date picker for HPHT
//   Future<void> _selectHphtDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedHphtDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != _selectedHphtDate) {
//       setState(() {
//         _selectedHphtDate = picked;
//         _hphtController.text = DateFormat('dd/MM/yyyy').format(_selectedHphtDate!);
//       });
//     }
//   }
//
//   // Function to handle the "Hitung" (Calculate) button press
//   void _calculateMasaSubur() {
//     if (_selectedHphtDate == null ||
//         _siklusMensController.text.isEmpty ||
//         _lamaMensController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Harap lengkapi semua data.')),
//       );
//       return;
//     }
//
//     final int? siklusMens = int.tryParse(_siklusMensController.text);
//     final int? lamaMens = int.tryParse(_lamaMensController.text);
//
//     if (siklusMens == null || lamaMens == null || siklusMens <= 0 || lamaMens <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Masukkan angka yang valid untuk siklus dan lama menstruasi.')),
//       );
//       return;
//     }
//
//     // --- Basic Masa Subur Calculation Logic (Simplified) ---
//     // This is a simplified calculation. For a real app, you'd need a more robust algorithm.
//     // Ovulation typically occurs around 14 days before the next period for a 28-day cycle.
//     // Masa Subur (Fertile Window) is usually a few days before and after ovulation.
//
//     // Calculate ovulation date: HPHT + (Siklus Mens - 14 hari)
//     // The image shows Masa Subur starting 6 days after the end of menstruation (HPHT + Lama Mens + 6 days)
//     // and ending on Ovulasi date + 2 days, or something similar.
//     // Let's mimic the image's displayed dates roughly.
//
//     // Menstruasi Start (HPHT)
//     final DateTime menstruasiStart = _selectedHphtDate!;
//     // Menstruasi End: HPHT + Lama Mens - 1 day
//     final DateTime menstruasiEnd = menstruasiStart.add(Duration(days: lamaMens - 1));
//
//     // Masa Subur Start: HPHT + Lama Mens + 6 days (as per typical calculation or image observation)
//     // A common method is (Siklus Mens - 18) days from HPHT to (Siklus Mens - 11) days from HPHT
//     // Let's use a simplified approach to match the image: HPHT + 14 days for start of fertile window
//     // For simplicity, let's assume a fixed fertile window relative to HPHT for demo:
//     // Masa Subur: HPHT + (siklusMens - 18) to HPHT + (siklusMens - 11)
//
//     // Let's calculate based on a 28-day cycle common logic:
//     // Ovulation is around day 14 from HPHT
//     // Fertile window is approx. day 10-17
//     final DateTime ovulasiDate = menstruasiStart.add(Duration(days: siklusMens - 14)); // Roughly
//     final DateTime masaSuburStart = menstruasiStart.add(Duration(days: siklusMens - 18));
//     final DateTime masaSuburEnd = menstruasiStart.add(Duration(days: siklusMens - 11));
//
//
//     // Navigate to the result screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MasaSuburResultScreen(
//           menstruasiStart: menstruasiStart,
//           menstruasiEnd: menstruasiEnd,
//           masaSuburStart: masaSuburStart,
//           masaSuburEnd: masaSuburEnd,
//           ovulasiDate: ovulasiDate,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text('Kalender Kehamilan'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Container(
//               alignment: Alignment.center,
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade50, // Light green background
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 children: [
//                   const Text(
//                     'Kalkulator Masa Subur & Kehamilan',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Rencanakan kehamilan secara matang dan dapatkan perkiraan\nhari kelahiran si kecil',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _buildInfoCard(
//                         context: context,
//                         label: 'Masa Subur',
//                         icon: Icons.calendar_today, // Placeholder icon
//                         imageAsset: 'assets/masa_subur_icon.png', // Replace with actual image
//                       ),
//                       const SizedBox(width: 20),
//                       _buildInfoCard(
//                         context: context,
//                         label: 'Masa Kehamilan',
//                         icon: Icons.child_care, // Placeholder icon
//                         imageAsset: 'assets/masa_kehamilan_icon.png', // Replace with actual image
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//
//             // HPHT Input
//             _buildLabeledInputField(
//               labelText: 'Mestruasi Terakhir (HPHT)?',
//               controller: _hphtController,
//               hintText: 'dd/mm/yyyy',
//               readOnly: true,
//               onTap: () => _selectHphtDate(context),
//               suffixIcon: Icons.calendar_today,
//             ),
//             const SizedBox(height: 20),
//
//             // Siklus Mens Input
//             _buildLabeledInputField(
//               labelText: 'Berapa Hari Siklus Mens Kamu?',
//               controller: _siklusMensController,
//               hintText: 'ketik disini',
//               suffixText: 'Hari',
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20),
//
//             // Lama Mens Input
//             _buildLabeledInputField(
//               labelText: 'Berapa Lama Mens Kamu?',
//               controller: _lamaMensController,
//               hintText: 'ketik disini',
//               suffixText: 'Hari',
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 40),
//
//             // Hitung Button
//             Center(
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _calculateMasaSubur,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.lightGreen,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                   child: const Text(
//                     'Hitung',
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
//   // Helper widget for the info cards (Masa Subur, Masa Kehamilan)
//   Widget _buildInfoCard({
//     required BuildContext context,
//     required String label,
//     IconData? icon, // Optional icon
//     String? imageAsset, // Optional image asset
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//         child: Column(
//           children: [
//             if (imageAsset != null) // Use image asset if provided
//               Image.asset(imageAsset, height: 50, width: 50)
//             else if (icon != null) // Otherwise, use icon if provided
//               Icon(icon, size: 50, color: Colors.green),
//             const SizedBox(height: 10),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper widget for labeled input fields
//   Widget _buildLabeledInputField({
//     required String labelText,
//     required TextEditingController controller,
//     required String hintText,
//     bool readOnly = false,
//     VoidCallback? onTap,
//     IconData? suffixIcon,
//     String? suffixText,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           labelText,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           readOnly: readOnly,
//           onTap: onTap,
//           keyboardType: keyboardType,
//           decoration: InputDecoration(
//             hintText: hintText,
//             border: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0)),
//             ),
//             suffixIcon: suffixIcon != null
//                 ? Icon(suffixIcon)
//                 : (suffixText != null
//                 ? Padding(
//               padding: const EdgeInsets.only(right: 12.0, left: 8.0),
//               child: Text(
//                 suffixText,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             )
//                 : null),
//             suffixIconConstraints: BoxConstraints(
//               minWidth: suffixIcon != null || suffixText != null ? 40 : 0, // Adjust size if icon/text exists
//               minHeight: 0,
//             ),
//             contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'masa_subur.dart'; // Import the new result screen

class HitungHpl extends StatefulWidget {
  const HitungHpl({super.key});

  @override
  State<HitungHpl> createState() => _HitungHplState();
}

class _HitungHplState extends State<HitungHpl> {
  // Text editing controllers for input fields
  final TextEditingController _hphtController = TextEditingController();
  final TextEditingController _siklusMensController = TextEditingController();
  final TextEditingController _lamaMensController = TextEditingController();

  // State to hold the selected date for HPHT
  DateTime? _selectedHphtDate;

  @override
  void dispose() {
    _hphtController.dispose();
    _siklusMensController.dispose();
    _lamaMensController.dispose();
    super.dispose();
  }

  // Function to show the date picker for HPHT
  Future<void> _selectHphtDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedHphtDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedHphtDate) {
      setState(() {
        _selectedHphtDate = picked;
        _hphtController.text = DateFormat('dd/MM/yyyy').format(_selectedHphtDate!);
      });
    }
  }

  // Function to handle the "Hitung" (Calculate) button press
  void _calculateMasaSubur() {
    if (_selectedHphtDate == null ||
        _siklusMensController.text.isEmpty ||
        _lamaMensController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data.')),
      );
      return;
    }

    final int? siklusMens = int.tryParse(_siklusMensController.text);
    final int? lamaMens = int.tryParse(_lamaMensController.text);

    if (siklusMens == null || lamaMens == null || siklusMens <= 0 || lamaMens <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan angka yang valid untuk siklus dan lama menstruasi.')),
      );
      return;
    }

    // --- Basic Masa Subur Calculation Logic (Simplified) ---
    // This is a simplified calculation. For a real app, you'd need a more robust algorithm.
    // Ovulation typically occurs around 14 days before the next period for a 28-day cycle.
    // Masa Subur (Fertile Window) is usually a few days before and after ovulation.

    // Calculate ovulation date: HPHT + (Siklus Mens - 14 hari)
    // The image shows Masa Subur starting 6 days after the end of menstruation (HPHT + Lama Mens + 6 days)
    // and ending on Ovulasi date + 2 days, or something similar.
    // Let's mimic the image's displayed dates roughly.

    // Menstruasi Start (HPHT)
    final DateTime menstruasiStart = _selectedHphtDate!;
    // Menstruasi End: HPHT + Lama Mens - 1 day
    final DateTime menstruasiEnd = menstruasiStart.add(Duration(days: lamaMens - 1));

    // Masa Subur Start: HPHT + Lama Mens + 6 days (as per typical calculation or image observation)
    // A common method is (Siklus Mens - 18) days from HPHT to (Siklus Mens - 11) days from HPHT
    // Let's use a simplified approach to match the image: HPHT + 14 days for start of fertile window
    // For simplicity, let's assume a fixed fertile window relative to HPHT for demo:
    // Masa Subur: HPHT + (siklusMens - 18) to HPHT + (siklusMens - 11)

    // Let's calculate based on a 28-day cycle common logic:
    // Ovulation is around day 14 from HPHT
    // Fertile window is approx. day 10-17
    final DateTime ovulasiDate = menstruasiStart.add(Duration(days: siklusMens - 14)); // Roughly
    final DateTime masaSuburStart = menstruasiStart.add(Duration(days: siklusMens - 18));
    final DateTime masaSuburEnd = menstruasiStart.add(Duration(days: siklusMens - 11));

    // --- Calculate Estimated Due Date (HPL) ---
    // Nagele's Rule: HPHT + 7 days - 3 months + 1 year (or simply HPHT + 280 days)
    final DateTime estimatedDueDate = menstruasiStart.add(const Duration(days: 280));


    // Navigate to the result screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MasaSuburResultScreen(
          menstruasiStart: menstruasiStart,
          menstruasiEnd: menstruasiEnd,
          masaSuburStart: masaSuburStart,
          masaSuburEnd: masaSuburEnd,
          ovulasiDate: ovulasiDate,
          estimatedDueDate: estimatedDueDate, // Pass HPL
        ),
      ),
    );
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
        title: const Text('Kalender Kehamilan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.green.shade50, // Light green background
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    'Kalkulator Masa Subur & Kehamilan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rencanakan kehamilan secara matang dan dapatkan perkiraan\nhari kelahiran si kecil',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInfoCard(
                        context: context,
                        label: 'Masa Subur',
                        icon: Icons.calendar_today, // Placeholder icon
                        imageAsset: 'assets/MasaSubur.png', // Replace with actual image
                      ),
                      const SizedBox(width: 20),
                      _buildInfoCard(
                        context: context,
                        label: 'Masa Kehamilan',
                        icon: Icons.child_care, // Placeholder icon
                        imageAsset: 'assets/MasaKehamilan.png', // Replace with actual image
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // HPHT Input
            _buildLabeledInputField(
              labelText: 'Mestruasi Terakhir (HPHT)?',
              controller: _hphtController,
              hintText: 'dd/mm/yyyy',
              readOnly: true,
              onTap: () => _selectHphtDate(context),
              suffixIcon: Icons.calendar_today,
            ),
            const SizedBox(height: 20),

            // Siklus Mens Input
            _buildLabeledInputField(
              labelText: 'Berapa Hari Siklus Mens Kamu?',
              controller: _siklusMensController,
              hintText: 'ketik disini',
              suffixText: 'Hari',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Lama Mens Input
            _buildLabeledInputField(
              labelText: 'Berapa Lama Mens Kamu?',
              controller: _lamaMensController,
              hintText: 'ketik disini',
              suffixText: 'Hari',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),

            // Hitung Button
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _calculateMasaSubur,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Hitung',
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

  // Helper widget for the info cards (Masa Subur, Masa Kehamilan)
  Widget _buildInfoCard({
    required BuildContext context,
    required String label,
    IconData? icon, // Optional icon
    String? imageAsset, // Optional image asset
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          children: [
            if (imageAsset != null) // Use image asset if provided
              Image.asset(imageAsset, height: 50, width: 50)
            else if (icon != null) // Otherwise, use icon if provided
              Icon(icon, size: 50, color: Colors.green),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for labeled input fields
  Widget _buildLabeledInputField({
    required String labelText,
    required TextEditingController controller,
    required String hintText,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
    String? suffixText,
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
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon)
                : (suffixText != null
                ? Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 8.0),
              child: Text(
                suffixText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
                : null),
            suffixIconConstraints: BoxConstraints(
              minWidth: suffixIcon != null || suffixText != null ? 40 : 0, // Adjust size if icon/text exists
              minHeight: 0,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          ),
        ),
      ],
    );
  }
}