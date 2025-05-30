import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
 //controler untuk setiap fiel 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _login() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email dan password tidak boleh kosong')),
    );
    return;
  }

  try {
    final userCredential = await _authService.signInWithEmailAndPassword(email, password);
    if (userCredential != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login berhasil')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login gagal: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header hijau
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              color: const Color(0xFF009966),
              child: const Center(
                child: SizedBox.shrink(), // Tidak ada gambar atau avatar
              ),
            ),

            const SizedBox(height: 20),

            // Judul Login
            const Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),

            const SizedBox(height: 30),

            // Input Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildTextField('Email', false, _emailController),
                  const SizedBox(height: 16),
                  _buildTextField('Password', true, _passwordController),
                  const SizedBox(height: 16),

                  // Tombol Masuk
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _login,
                      child: const Text(
                        'Masuk',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Lupa password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _login,
                      child: const Text(
                        'Lupa password?',
                        style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Atau login langsung melalui',
                    style: TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 16),

                  // Tombol login dengan Google
                  IconButton(
                    icon: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png',
                      height: 40,
                    ),
                    onPressed: () async {
                      final user = await AuthService().signInWithGoogle();
    
                      if (!context.mounted) return;
    
                      if (user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login Google berhasil!')),
                        );
                        Navigator.pushReplacementNamed(context, '/home'); // Tambahkan navigasi ke home
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login Google gagal!')),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // Tautan daftar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun?',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Masuk disini',
                          style: TextStyle(color: Colors.cyan),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    '@Security Analyze By Drupadity',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, bool obscure, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: obscure,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
