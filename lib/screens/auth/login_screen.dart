import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../main_navigation_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: 'nadia@mahasiswa.ac.id');
  final TextEditingController _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;
  String? _authError;
  bool _isLoading = false;

  void _validateAndLogin() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _authError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool hasError = false;

    if (email.isEmpty) {
      _emailError = 'Email wajib diisi';
      hasError = true;
    } else if (!email.contains('@') || !email.contains('.')) {
      _emailError = 'Format email tidak valid';
      hasError = true;
    }

    if (password.isEmpty) {
      _passwordError = 'Password wajib diisi';
      hasError = true;
    } else if (password.length < 6) {
      _passwordError = 'Password minimal 6 karakter';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    // Check credentials simulation
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Successfully authenticated
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Header Brand
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Mahastudy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              // Greeting
              const Row(
                children: [
                  Text(
                    'Selamat datang',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '👋',
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Masuk dan atur hari kuliahmu\ndengan lebih tenang.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              // Form Fields
              CustomTextField(
                label: 'Email',
                hint: 'nama@email.com',
                controller: _emailController,
                errorText: _emailError,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) {
                  if (_emailError != null) setState(() => _emailError = null);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                hint: 'Masukkan password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                errorText: _passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 20,
                    color: AppTheme.textMuted,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                onChanged: (_) {
                  if (_passwordError != null) setState(() => _passwordError = null);
                },
              ),
              if (_authError != null) ...[
                const SizedBox(height: 12),
                Text(
                  _authError!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.danger,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 28),
              // Login Button
              PrimaryButton(
                text: 'Login',
                isLoading: _isLoading,
                onPressed: _validateAndLogin,
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Isi email dan password untuk melanjutkan.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Footer link to Register
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Belum punya akun? ',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Daftar',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
