import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../main_navigation_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Nadia');
  final TextEditingController _emailController = TextEditingController(text: 'nadia@mahasiswa.ac.id');
  final TextEditingController _passwordController = TextEditingController(text: 'password123');
  final TextEditingController _confirmPasswordController = TextEditingController(text: 'password123');
  
  String? _selectedMajor = 'Informatika';
  final List<String> _majors = [
    'Informatika',
    'Sistem Informasi',
    'Teknologi Informasi',
    'Teknik Komputer',
    'Sains Data',
  ];

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

  void _validateAndRegister() {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    bool hasError = false;

    if (name.isEmpty) {
      _nameError = 'Nama wajib diisi';
      hasError = true;
    }

    if (email.isEmpty) {
      _emailError = 'Email wajib diisi';
      hasError = true;
    } else if (!email.contains('@')) {
      _emailError = 'Format email tidak valid';
      hasError = true;
    }

    if (password.isEmpty) {
      _passwordError = 'Password wajib diisi';
      hasError = true;
    } else if (password.length < 8) {
      _passwordError = 'Minimal 8 karakter';
      hasError = true;
    }

    if (confirm != password) {
      _confirmPasswordError = 'Password tidak sama';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Navigate to Home with success toast banner
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(showAccountCreatedToast: true),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Back Arrow and Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Mahastudy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Buat akun',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Mulai perjalanan kuliah yang lebih teratur.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Nama',
                hint: 'Nama lengkap',
                controller: _nameController,
                errorText: _nameError,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Email',
                hint: 'nama@email.com',
                controller: _emailController,
                errorText: _emailError,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              // Major dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Program studi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedMajor,
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.cardBorder, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
                      ),
                    ),
                    items: _majors.map((m) {
                      return DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 14)));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedMajor = val),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Password',
                hint: 'Minimal 8 karakter',
                controller: _passwordController,
                obscureText: _obscurePassword,
                errorText: _passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 20,
                    color: AppTheme.textMuted,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Konfirmasi password',
                hint: 'Ulangi password',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                errorText: _confirmPasswordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 20,
                    color: AppTheme.textMuted,
                  ),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              const SizedBox(height: 26),
              PrimaryButton(
                text: 'Daftar',
                isLoading: _isLoading,
                onPressed: _validateAndRegister,
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Semua siap. Yuk, mulai bersama Mahastudy!',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Center(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Sudah punya akun? ',
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
