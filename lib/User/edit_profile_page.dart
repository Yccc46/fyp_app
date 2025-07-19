import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Layout/app_header.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController usernameController = TextEditingController(text: "JohnDoe");
  final TextEditingController phoneController = TextEditingController(text: "123456789");
  final TextEditingController addressController = TextEditingController(text: "123 Green Lane, KL");
  final TextEditingController emailController = TextEditingController(text: "john.doe@email.com");
  final TextEditingController phoneVerifyCodeController = TextEditingController();
  final TextEditingController emailVerifyCodeController = TextEditingController();

  bool isPhoneVerified = true;
  bool isEmailVerified = true;
  bool showPhoneVerifyField = false;
  bool showEmailVerifyField = false;
  bool hasChanged = false;

  XFile? selectedImage;

  bool get isSaveEnabled {
    return hasChanged &&
        isPhoneVerified &&
        isEmailVerified &&
        usernameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        emailController.text.isNotEmpty;
  }

  void _onFieldChanged() {
    setState(() {
      hasChanged = true;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
        hasChanged = true;
      });
    }
  }

  void _saveProfile() {
    Navigator.pop(context, {
      'username': usernameController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'email': emailController.text,
      'image': selectedImage?.path,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppHeader(),
              const SizedBox(height: 12),
              const Text("Edit Profile",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: selectedImage != null
                        ? FileImage(File(selectedImage!.path))
                        : const AssetImage('assets/Image/Profile_logo.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(usernameController.text,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              _buildTextField(Icons.person, "Username", usernameController),
              _buildPhoneField(),
              if (showPhoneVerifyField)
                _buildVerifyCodeField(phoneVerifyCodeController, "Phone verification code"),
              _buildTextField(Icons.home, "Address", addressController),
              _buildEmailField(),
              if (showEmailVerifyField)
                _buildVerifyCodeField(emailVerifyCodeController, "Email verification code"),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSaveEnabled ? _saveProfile : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSaveEnabled ? Colors.green : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        onChanged: (_) => _onFieldChanged(),
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        onChanged: (_) {
          _onFieldChanged();
          setState(() {
            showPhoneVerifyField = true;
            isPhoneVerified = false;
          });
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(width: 12),
              Icon(Icons.phone),
              SizedBox(width: 6),
              Text("+60 |", style: TextStyle(fontSize: 16, color: Colors.black54)),
              SizedBox(width: 6),
            ],
          ),
          hintText: "Phone Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          suffixIcon: TextButton(
            onPressed: () {
              setState(() {
                showPhoneVerifyField = true;
              });
            },
            child: const Text("Verify"),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: emailController,
        onChanged: (_) {
          _onFieldChanged();
          setState(() {
            showEmailVerifyField = true;
            isEmailVerified = false;
          });
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          hintText: "Email Address",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: TextButton(
            onPressed: () {
              setState(() {
                showEmailVerifyField = true;
              });
            },
            child: const Text("Verify"),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyCodeField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        onChanged: (_) => _onFieldChanged(),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}