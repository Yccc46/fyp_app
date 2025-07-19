import 'package:flutter/material.dart';
import 'dart:async';
import '../Layout/app_header.dart';

class EmailOtpPage extends StatefulWidget {
  const EmailOtpPage({super.key});

  @override
  State<EmailOtpPage> createState() => _EmailOtpPageState();
}

class _EmailOtpPageState extends State<EmailOtpPage> {
  final List<TextEditingController> _otpControllers =
  List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());
  String? _errorMessage;

  int _secondsRemaining = 60;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _resendOtp() {
    // TODO: Trigger system to resend OTP
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP resent")),
    );
    _startCountdown();
  }

  void _verifyOtp() {
    String otp = _otpControllers.map((e) => e.text).join();
    if (otp.length == 5) {
      // TODO: Compare with real OTP
      bool isCorrect = otp == "12345"; // Placeholder
      if (isCorrect) {
        Navigator.pushNamed(context, '/change_password');
      } else {
        setState(() => _errorMessage = "Incorrect OTP. Please try again.");
      }
    }
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 4) {
            _focusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {});
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isOtpComplete =
    _otpControllers.every((controller) => controller.text.isNotEmpty);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),

              // Back Button
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 24),

              const Center(
                child: Text(
                  "OTP Verification",
                  style: TextStyle(
                      color: Color(0xFF425855),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              const Center(
                child: Text(
                  "Please Enter 5 digits OTP",
                  style: TextStyle(
                      color: Color(0xFF425855),
                      fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, _buildOtpBox),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Resend Button
                  SizedBox(
                    width: 145,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _canResend ? _resendOtp : null,
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                        _canResend ? Colors.white : Colors.grey[300],
                        side: BorderSide(
                          color:
                          _canResend ? const Color(0xFF425855) : Colors.grey,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _canResend
                            ? "Resend"
                            : "Resend ($_secondsRemaining)",
                        style: const TextStyle(
                          color: Color(0xFF425855),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  //Next Button
                  SizedBox(
                    width: 145,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: isOtpComplete ? _verifyOtp : null,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color:
                          isOtpComplete ? const Color(0xFF425855) : Colors.grey,
                          width: 1.5,
                        ),
                        backgroundColor:
                        isOtpComplete ? Colors.green[200] : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Next >",
                        style: TextStyle(
                          color: Color(0xFF425855),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),


              if (_errorMessage != null) ...[
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
