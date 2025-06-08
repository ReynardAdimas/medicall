import 'package:flutter/material.dart';
import 'package:supaaaa/pages/login_page.dart';


import '../auth/auth_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // get auth service
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  final authService = AuthService();

  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void register() async {
    // prepare data
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;


    if(password != confirmPassword)
      {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password yang anda masukkan tidak sama")));
        return;
      }

    try {
      await authService.signUpWithEmailPassword(email, password);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password harus terdiri dari 6 karakter dan harus mengandung huruf kecil, huruf besar, digit angka dan simbol")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Kembali & Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Image.asset(
                    'assets/LogoMedicall.png',
                    height: 60,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Email
              const Text('Alamat Email'),
              const SizedBox(height: 8),
              _buildTextField( 'ketik disini', _emailController),

              const SizedBox(height: 16),

              // Kata Sandi
              const Text('Kata Sandi'),
              const SizedBox(height: 8),
              _buildPasswordField(
                'ketik disini',
                _obscurePassword,
                    () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                _passwordController,
              ),


              const SizedBox(height: 16),

              // Konfirmasi Sandi
              const Text('Konfirmasi Kata Sandi'),
              const SizedBox(height: 8),
              _buildPasswordField(
                'ketik disini',
                _obscureConfirm,
                    () {
                  setState(() {
                    _obscureConfirm = !_obscureConfirm;
                  });
                },
                _confirmPasswordController,
              ),


              const SizedBox(height: 32),

              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF95E06C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: register,
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController ct) {
    return TextField(
      controller: ct,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String hint,
      bool obscureText,
     VoidCallback toggle,
      TextEditingController ct
  ) {
    return TextField(
      controller: ct,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: toggle,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
