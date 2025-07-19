import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class StartTheme extends StatefulWidget {
  const StartTheme({super.key});

  @override
  State<StartTheme> createState() => _StartThemeState();
}

class _StartThemeState extends State<StartTheme> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndNavigate();
  }

  Future<void> _requestPermissionsAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    // request location
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }

    // request camera
    await Permission.camera.request();

    // Load into the login page
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: Center(
        child: Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xFF425855),
              width: 4,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset('assets/Image/FYP_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
