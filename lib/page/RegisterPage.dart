// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:klinik/service/AuthRepository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _authRepository = AuthRepository();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();
  final _nikController = TextEditingController();

  String? _jenisKelamin;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    _nikController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap setujui syarat dan ketentuan'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepository.register(
        name: _namaController.text,
        email: _emailController.text,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        tanggalLahir: _tanggalLahirController.text,
        jenisKelamin: _jenisKelamin!, // aman karena sudah divalidasi
        alamat: _alamatController.text,
        telepon: _teleponController.text,
        nik: _nikController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil! Silakan login'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      print(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception:', '').trim()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF4A90E2)),
      filled: true,
      fillColor: const Color(0xFFF7FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Buat Akun',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Daftar untuk memulai layanan kesehatan',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
                const SizedBox(height: 40),

                /// NAMA
                TextFormField(
                  controller: _namaController,
                  decoration: _inputDecoration(
                    'Masukkan nama lengkap',
                    Icons.person_outline,
                  ),
                  validator:
                      (v) =>
                          v == null || v.isEmpty
                              ? 'Nama tidak boleh kosong'
                              : null,
                ),
                const SizedBox(height: 20),

                /// EMAIL
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(
                    'Masukkan email Anda',
                    Icons.email_outlined,
                  ),
                  validator:
                      (v) =>
                          v == null || !v.contains('@')
                              ? 'Email tidak valid'
                              : null,
                ),
                const SizedBox(height: 20),

                /// PASSWORD
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration(
                    'Minimal 6 karakter',
                    Icons.lock_outline,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed:
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                    ),
                  ),
                  validator:
                      (v) =>
                          v != null && v.length >= 6
                              ? null
                              : 'Password minimal 6 karakter',
                ),
                const SizedBox(height: 20),

                /// KONFIRMASI PASSWORD
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: _inputDecoration(
                    'Ulangi password Anda',
                    Icons.lock_outline,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed:
                          () => setState(
                            () =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                          ),
                    ),
                  ),
                  validator:
                      (v) =>
                          v == _passwordController.text
                              ? null
                              : 'Password tidak sama',
                ),
                const SizedBox(height: 20),

                /// TANGGAL LAHIR
                TextFormField(
                  controller: _tanggalLahirController,
                  readOnly: true,
                  decoration: _inputDecoration(
                    'Tanggal lahir',
                    Icons.calendar_today,
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                    );
                    if (date != null) {
                      _tanggalLahirController.text =
                          date.toIso8601String().split('T').first;
                    }
                  },
                  validator:
                      (v) =>
                          v == null || v.isEmpty ? 'Tanggal lahir wajib' : null,
                ),
                const SizedBox(height: 20),

                /// JENIS KELAMIN
                DropdownButtonFormField<String>(
                  value: _jenisKelamin,
                  decoration: _inputDecoration(
                    'Jenis kelamin',
                    Icons.people_outline,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Laki-laki',
                      child: Text('Laki-laki'),
                    ),
                    DropdownMenuItem(
                      value: 'Perempuan',
                      child: Text('Perempuan'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _jenisKelamin = v),
                  validator: (v) => v == null ? 'Pilih jenis kelamin' : null,
                ),
                const SizedBox(height: 20),

                /// ALAMAT
                TextFormField(
                  controller: _alamatController,
                  decoration: _inputDecoration(
                    'Alamat lengkap',
                    Icons.home_outlined,
                  ),
                  validator:
                      (v) =>
                          v == null || v.isEmpty ? 'Alamat wajib diisi' : null,
                ),
                const SizedBox(height: 20),

                /// TELEPON
                TextFormField(
                  controller: _teleponController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration(
                    'Nomor telepon',
                    Icons.phone_outlined,
                  ),
                  validator:
                      (v) =>
                          v == null || v.isEmpty ? 'Telepon wajib diisi' : null,
                ),
                const SizedBox(height: 20),

                /// NIK
                TextFormField(
                  controller: _nikController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('NIK', Icons.badge_outlined),
                ),
                const SizedBox(height: 20),

                /// TERMS
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      activeColor: const Color(0xFF4A90E2),
                      onChanged:
                          (v) => setState(() => _agreedToTerms = v ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        'Saya setuju dengan Syarat & Ketentuan',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          color: Color(0xFF4A90E2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
