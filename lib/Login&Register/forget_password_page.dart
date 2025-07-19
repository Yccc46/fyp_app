import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'email_otp_page.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;

  void _onEmailChanged(String value) {
    setState(() {
      _isEmailValid = EmailValidator.validate(value.trim());
    });
  }

  void _onNextPressed() {
    if (_isEmailValid) {
      // Show SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email Verification OTP sent"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 80, left: 24, right: 24),
        ),
      );

      // Navigate to OTP page in 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmailOtpPage()),
          );
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // Ivory
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo & App Name
              Row(
                children: [
                  Image.asset('assets/Image/FYP_logo.png', width: 40, height: 40),
                  const SizedBox(width: 8),
                  const Text(
                    "Garbage Classification",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF425855),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Back Button
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 24),

              // Title
              const Center(
                child: Text(
                  "Forget Password",
                  style: TextStyle(
                      color: Color(0xFF425855),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),

              // Email input box
              TextFormField(
                controller: _emailController,
                onChanged: _onEmailChanged,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  prefixIcon: const Icon(Icons.email),
                  errorMaxLines: 2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 12.0,
                  ),
                ),
                validator: (value) =>
                EmailValidator.validate(value ?? '') ? null : "Enter a valid email",
              ),
              const SizedBox(height: 24),

              // Next Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _isEmailValid ? _onNextPressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                      _isEmailValid ? Colors.green[200] : Colors.grey,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 65),
                  ),
                  child: const Text(
                    "Next >",
                    style: TextStyle(color: Color(0xFF425855), fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
