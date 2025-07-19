import 'package:flutter/material.dart';
import '../Layout/app_header.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _toggleOldPasswordVisibility() {
    setState(() => _obscureOldPassword = !_obscureOldPassword);
  }

  void _toggleNewPasswordVisibility() {
    setState(() => _obscureNewPassword = !_obscureNewPassword);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
  }

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset successfully")),
      );

      Navigator.pop(context); // back to profile
    }
  }

  Widget buildPasswordField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    required String fieldType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$fieldType is required";
        }

        // format
        final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#&*~]).{8,}$');
        if (!regex.hasMatch(value)) {
          return "Password must be at least 8 characters, including upper/lowercase, number and special character (!@#&*~).";
        }

        if (fieldType == "Old Password") {
          //
          const storedPassword = "OldPassword@123"; // demo old password
          if (value != storedPassword) {
            return "Incorrect old password";
          }
        }

        if (fieldType == "New Password") {
          if (value == _oldPasswordController.text) {
            return "New password must be different from old password";
          }
        }

        if (fieldType == "Confirm New Password") {
          if (value != _newPasswordController.text) {
            return "Passwords do not match";
          }
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        errorMaxLines: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),

              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 24),

              const Center(
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Color(0xFF425855),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 26),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildPasswordField(
                      hint: "Old Password",
                      icon: Icons.lock_outline,
                      controller: _oldPasswordController,
                      obscureText: _obscureOldPassword,
                      onToggle: _toggleOldPasswordVisibility,
                      fieldType: "Old Password",
                    ),
                    const SizedBox(height: 16),

                    buildPasswordField(
                      hint: "New Password",
                      icon: Icons.lock,
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      onToggle: _toggleNewPasswordVisibility,
                      fieldType: "New Password",
                    ),
                    const SizedBox(height: 16),

                    buildPasswordField(
                      hint: "Confirm New Password",
                      icon: Icons.lock,
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      onToggle: _toggleConfirmPasswordVisibility,
                      fieldType: "Confirm New Password",
                    ),
                    const SizedBox(height: 26),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _savePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            color: Color(0xFF425855),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}