import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
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
  bool _isNotRegistered = false;
  bool _isLoading = false;

  void _validateAndLogin() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _authError = null;
      _isNotRegistered = false;
    });

    final identifier = _emailController.text.trim();
    final password = _passwordController.text;

    bool hasError = false;

    if (identifier.isEmpty) {
      _emailError = 'Email atau nama wajib diisi';
      hasError = true;
    } else if (identifier.contains('@') && !identifier.contains('.')) {
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

    // Check credentials against registered accounts
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final account = MockData().findAccount(identifier);

      // If user/account is not registered, show error and direct to register
      if (account == null) {
        setState(() {
          _isNotRegistered = true;
          _emailError = 'Akun belum terdaftar';
          _authError = 'Nama atau email "$identifier" belum terdaftar. Silakan buat akun terlebih dahulu.';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Akun "$identifier" belum terdaftar.'),
            backgroundColor: AppTheme.danger,
            action: SnackBarAction(
              label: 'Buat Akun',
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
            ),
          ),
        );
        return;
      }

      // Check if password matches
      if (account.password != password) {
        setState(() {
          _isNotRegistered = false;
          _passwordError = 'Password salah';
          _authError = 'Password yang Anda masukkan salah. Silakan coba lagi.';
        });
        return;
      }

      // Successfully authenticated
      MockData().currentUser = account.user;
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
                label: 'Email atau Nama',
                hint: 'nama@email.com atau nama lengkap',
                controller: _emailController,
                errorText: _emailError,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) {
                  if (_emailError != null || _authError != null || _isNotRegistered) {
                    setState(() {
                      _emailError = null;
                      _authError = null;
                      _isNotRegistered = false;
                    });
                  }
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
                  if (_passwordError != null || _authError != null) {
                    setState(() {
                      _passwordError = null;
                      _authError = null;
                    });
                  }
                },
              ),
              if (_isNotRegistered) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.danger.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Akun Belum Terdaftar',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.danger,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _authError ?? 'Akun ini belum terdaftar. Silakan buat akun terlebih dahulu.',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF991B1B),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RegisterScreen()),
                            );
                          },
                          icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                          label: const Text('Buat Akun Terlebih Dahulu'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.danger,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (_authError != null) ...[
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
