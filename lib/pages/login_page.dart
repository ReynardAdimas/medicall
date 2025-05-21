import 'package:flutter/material.dart';
import 'package:supaaaa/auth/auth_services.dart';
import 'package:supaaaa/pages/register_page_1.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // get auth service
  final authService = AuthService();

  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // lupa password
  void lupaPassword() async {
    final email = _emailController.text;
    if(email.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mohon isikan email anda'))
      );
      return;
    }

    try {
      await authService.sendResetPasswordEmail(email);
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent'))
        );
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
        );
      }
    }
  }

  // login button pressed
  void login() async {
    // prepare data
    final email = _emailController.text;
    final password = _passwordController.text;

    // attempt login...
    try{
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }


  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: ListView(
        children: [
          // email
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          // password
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: "Password"),
          ),
          // button
          ElevatedButton(
              onPressed: login,
              child: const Text("Login")
          ),

          // go to register page
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage1())),
            child: Center(
              child: Text("Dont have account? Sign Up"),
            ),
          ),
          GestureDetector(
            onTap: lupaPassword,
            child: Center(
              child: Text("Forgot Password"),
            ),
          )

        ],
      ),
    );
  }
}
