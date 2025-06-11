import 'package:flutter/material.dart';
import 'package:supaaaa/auth/auth_services.dart';
import 'package:supaaaa/pages/register_page.dart';
import 'package:supaaaa/pages/register_page_1.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // get auth service
  final authService = AuthService();
  final supabase = Supabase.instance.client;

  bool _isLoading = false;

  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // lupa password
  // void lupaPassword() async {
  //   final email = _emailController.text;
  //   if(email.isEmpty){
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Mohon isikan email anda'))
  //     );
  //     return;
  //   }
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     await authService.sendResetPasswordEmail(email);
  //     if(mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Password reset email sent'))
  //       );
  //     }
  //   } catch (e) {
  //     if(mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $e'))
  //       );
  //     }
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // login button pressed
  void login() async {
    // prepare data
    final email = _emailController.text;
    final password = _passwordController.text;
    setState(() {
      _isLoading = true;
    });
    try{
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email atau Password anda mungkin salah")));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo dan Judul
                Column(
                  children: [
                    Image.asset('assets/LogoMedicall.png'),
                    SizedBox(height: 8),
                    Text(
                      'MediCall',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 48),

                // Email Input
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Alamat Email',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'ketik disini',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),

                SizedBox(height: 20),

                // Password Input
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Kata Sandi',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 8),
                _buildPasswordField(
                  'ketik disini',
                  _obscureConfirm,
                      () {
                    setState(() {
                      _obscureConfirm = !_obscureConfirm;
                    });
                  },
                  _passwordController,
                ),

                SizedBox(height: 12),

                // Buat akun
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Tidak punya akun? "),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                      child: Text(
                        "Buat akun",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32),

                // Tombol Masuk
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    child: _isLoading
                            ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                           : Text(
                      'Masuk',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
