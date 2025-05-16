import 'package:flutter/material.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

enum AuthMode { login, signup }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedCity;
  AuthMode _authMode = AuthMode.login;

  void _swithMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _authMode == AuthMode.signup
            ? Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTextField(
                          controller: _usernameController,
                          label: 'اسم المستخدم',
                          validator: (value) => value == null || value.isEmpty
                              ? 'الرجاء إدخال اسم المستخدم'
                              : null,
                        ),
                        _buildTextField(
                          controller: _emailController,
                          label: 'البريد الإلكتروني',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'بريد إلكتروني غير صالح';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'رقم الهاتف',
                          keyboardType: TextInputType.phone,
                          validator: (value) => value == null || value.isEmpty
                              ? 'الرجاء إدخال رقم الهاتف'
                              : null,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'اختر المدينة',
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          value: _selectedCity,
                          onChanged: (value) =>
                              setState(() => _selectedCity = value),
                          validator: (value) =>
                              value == null ? 'الرجاء اختيار المدينة' : null,
                          items: const [
                            DropdownMenuItem(
                                value: "شندي", child: Text("شندي")),
                            DropdownMenuItem(
                                value: "الخرطوم", child: Text("الخرطوم")),
                            DropdownMenuItem(
                                value: "عطبرة", child: Text("عطبرة")),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'كلمة السر',
                          obscureText: true,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          validator: (value) =>
                              value == null || value.length < 6
                                  ? 'كلمة السر يجب أن تكون 6 أحرف على الأقل'
                                  : null,
                        ),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: 'تكرار كلمة السر',
                          obscureText: true,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          validator: (value) =>
                              value != _passwordController.text
                                  ? 'كلمتا السر غير متطابقتين'
                                  : null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text("لديك حساب مسبقا"),
                            TextButton(
                              onPressed: () {
                                _swithMode();
                              },
                              child: const Text("تسجيل دخول"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final AuthProvider authProvider =
                                  Provider.of<AuthProvider>(context,
                                      listen: false);
                              authProvider.signupuser(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  _usernameController.text.trim(),
                                  _selectedCity.toString(),
                                  _phoneController.text.trim());
                            }
                          },
                          child: const Text("Signup"),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Forgot Password?"),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTextField(
                          controller: _emailController,
                          label: 'البريد الإلكتروني',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'بريد إلكتروني غير صالح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'كلمة السر',
                          obscureText: true,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          validator: (value) =>
                              value == null || value.length < 6
                                  ? 'كلمة السر يجب أن تكون 6 أحرف على الأقل'
                                  : null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text("لديك حساب مسبقا"),
                            TextButton(
                              onPressed: () {
                                _swithMode();
                              },
                              child: const Text("تسجيل دخول"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final AuthProvider authProvider =
                                  Provider.of<AuthProvider>(context,
                                      listen: false);
                              await authProvider.login(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  context);
                            }
                          },
                          child: const Text("Signup"),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Forgot Password?"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextAlign textAlign = TextAlign.end,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        textAlign: textAlign,
        textDirection: textDirection,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade300,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          errorStyle:
              const TextStyle(height: 1.2, fontSize: 12, color: Colors.red),
        ),
      ),
    );
  }
}
