import 'package:flutter/material.dart';

class WebOnlyPage extends StatelessWidget {
  const WebOnlyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: const Center(
        child: Text(
          'Only Available on the Website.',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
