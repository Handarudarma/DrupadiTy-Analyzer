import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller untuk setiap TextField
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _register() async {
    try {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password tidak sama')),
        );
        return;
      }

      await _authService.registerWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _namaController.text,
        _phoneController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil')),
        );
        Navigator.pushReplacementNamed(context, '/login'); // Kembali ke halaman login
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi gagal: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Membersihkan controller saat widget di dispose
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                child: SizedBox.shrink(), // Tidak ada avatar/gambar
              ),
            ),

            const SizedBox(height: 20),

            // Judul Daftar
            const Text(
              'Daftar Manual',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTextField('Nama', false),
                    const SizedBox(height: 10),
                    _buildTextField('Email', false),
                    const SizedBox(height: 10),
                    _buildTextField('Password', true),
                    const SizedBox(height: 10),

                    // Nomor telepon dengan kode negara (tanpa flag)
                    Row(
                      children: [
                        const Text(
                          '+62',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField('Nomor Telepon', false),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    _buildTextField('Ulangi Password', true),

                    const SizedBox(height: 20),

                    // Update tombol daftar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _register,  // Tambahkan fungsi register
                        child: const Text(
                          'Buat Akun',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Syarat dan ketentuan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Dengan mendaftar kamu wajib menyetujui',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Syarat ketentuan & kebijakan privasi',
                      style: TextStyle(color: Colors.white, fontSize: 12, decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Atau daftar langsung melalui',
              style: TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 16),

            IconButton(
              icon: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png',
                height: 40,
              ),
              onPressed: () {
                // login google
              },
            ),

            const SizedBox(height: 20),

            // Sudah punya akun
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sudah punya akun?',
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                   Navigator.pushNamed(context, '/'); // Navigasi ke halaman login
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
    );
  }

  Widget _buildTextField(String label, bool obscure) {
    // Menentukan controller berdasarkan label
    TextEditingController controller;
    switch (label) {
      case 'Nama':
        controller = _namaController;
        break;
      case 'Email':
        controller = _emailController;
        break;
      case 'Password':
        controller = _passwordController;
        break;
      case 'Nomor Telepon':
        controller = _phoneController;
        break;
      case 'Ulangi Password':
        controller = _confirmPasswordController;
        break;
      default:
        controller = TextEditingController();
    }

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
