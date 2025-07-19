import 'dart:io';
import 'package:flutter/material.dart';
import '../Layout/app_header.dart';

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;

  const ImagePreviewPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    const darkColor = Color(0xFF425855);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo 和 App 名称
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: AppHeader(),
              ),

              // Back 按钮
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: darkColor),
                  label: const Text("Back", style: TextStyle(color: darkColor)),
                ),
              ),

              const SizedBox(height: 8),

              // 图片显示区域
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Confirm 按钮
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Confirm"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/classification',
                    arguments: {
                      'imagePath': imagePath,
                    },
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
