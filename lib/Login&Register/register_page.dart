import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedCity;
  String? _selectedState;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final List<String> _malaysianStates = [
    'Johor', 'Kedah', 'Kelantan', 'Melaka', 'Negeri Sembilan',
    'Pahang', 'Pulau Pinang', 'Perak', 'Perlis', 'Sabah',
    'Sarawak', 'Selangor', 'Terengganu'
  ];

  final List<String> _malaysianCities = [
    'Penang Island', 'Kuala Lumpur', 'Ipoh', 'Kuching', 'Johor Bahru',
    'Putrajaya', 'Kota Kinabalu', 'Shah Alam', 'Melaka', 'Alor Setar',
    'Miri', 'Petaling Jaya', 'Kuala Terengganu', 'Iskandar Puteri',
    'Seberang Perai', 'Seremban','Subang Jaya', 'Pasir Gudang', 'Kuantan','Klang'
  ];

  final Map<String, String> locationToStateMap = {
    "Tanjung Bungah": "Pulau Pinang", "George Town": "Pulau Pinang", "Bayan Lepas": "Pulau Pinang",
    "Butterworth": "Pulau Pinang", "Bukit Mertajam": "Pulau Pinang", "Kuala Lumpur": "Kuala Lumpur",
    "Setapak": "Kuala Lumpur", "Cheras": "Kuala Lumpur", "Shah Alam": "Selangor", "Petaling Jaya": "Selangor",
    "Subang Jaya": "Selangor", "Puchong": "Selangor", "Rawang": "Selangor", "Johor Bahru": "Johor",
    "Skudai": "Johor", "Batu Pahat": "Johor", "Kluang": "Johor", "Kota Kinabalu": "Sabah", "Sandakan": "Sabah",
    "Tawau": "Sabah", "Kuching": "Sarawak", "Miri": "Sarawak", "Sibu": "Sarawak", "Ipoh": "Perak",
    "Alor Setar": "Kedah", "Kangar": "Perlis", "Kota Bharu": "Kelantan", "Kuala Terengganu": "Terengganu",
    "Seremban": "Negeri Sembilan", "Melaka": "Melaka", "Putrajaya": "Putrajaya", "Labuan": "Labuan"
  };

  void _togglePasswordVisibility() => setState(() => _obscurePassword = !_obscurePassword);
  void _toggleConfirmPasswordVisibility() => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);

  Future<void> _locateAddress() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ?? '';
        final rawState = place.administrativeArea ?? '';
        final mappedState = locationToStateMap[city] ?? locationToStateMap[rawState] ?? rawState;
        final validCity = _malaysianCities.contains(city) ? city : null;
        final validState = _malaysianStates.contains(mappedState) ? mappedState : null;
        setState(() {
          _addressController.text = "${place.street ?? ''}, $city, ${place.postalCode ?? ''}, $mappedState";
          _streetController.text = place.street ?? '';
          _postalCodeController.text = place.postalCode ?? '';
          _cityController.text = validCity ?? '';
          _stateController.text = validState ?? '';
        });
      }
    } catch (e) {
      print("Location error: $e");
    }
  }

  Future<bool> _emailExists(String email) async {
    final doc = await FirebaseFirestore.instance
        .collection('User')
        .doc(email.trim())
        .get();
    return doc.exists;
  }


  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 检查 Email 是否已存在于 Firestore
    if (await _emailExists(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email already existed.")),
      );
      return;
    }

    // 注册 Firebase Auth 用户（必须）
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 注册 Firestore 用户数据
    await FirebaseFirestore.instance.collection('User').doc(email).set({
      'Username': _usernameController.text.trim(),
      'Email_Address': email,
      'Phone_Number': _phoneController.text.trim().isEmpty
          ? null
          : '+60${_phoneController.text.trim()}',
      'Address': {
        'Address': _addressController.text.trim(),
        'Street': _streetController.text.trim(),
        'City': _selectedCity,
        'PostalCode': _postalCodeController.text.trim(),
        'State': _selectedState,
      },
      'Login_Method': 'Email Login',
      'Google_ID': null,
      'Point': 0,
      'Profile_Picture': null,
      'Created_Date': Timestamp.now(),
      'Role': 'User',
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign Up Successful!")),
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/login');
    }
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    AutovalidateMode? autovalidateMode,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        suffixIcon: suffixIcon,
        errorMaxLines: 3,
        errorStyle: const TextStyle(fontSize: 11, height: 1.2),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
    );
  }


  Widget _buildLabeledField(String label, Widget field, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [if (required) const TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
          ),
        ),
        const SizedBox(height: 6),
        field,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green[200],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const Text(
                    "REGISTER",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF425855)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildLabeledField("Username", _buildTextField(
                        controller: _usernameController,
                        hint: "Username",
                        icon: Icons.person,
                        validator: (v) => v == null || v.isEmpty ? "Required" : null,
                      ), required: true),
                      const SizedBox(height: 10),

                      //Email Input field
                      _buildLabeledField("Email", _buildTextField(
                        controller: _emailController,
                        hint: "Email",
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,  // realtime validate
                        validator: (v) =>
                        v != null && EmailValidator.validate(v) ? null : "Enter a valid email (e.g. example@gmail.com)",
                      ), required: true),
                      const SizedBox(height: 10),

                      //Phone Number Input Field
                      _buildLabeledField(
                        "Phone Number",
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                          value == null || value.isEmpty || !RegExp(r'^[1-9][0-9]{8,9}$').hasMatch(value)
                              ? "Invalid phone number. Enter last 9–10 digits." : null,
                          decoration: InputDecoration(
                            hintText: "Phone Number",
                            hintStyle: const TextStyle(fontSize: 13),
                            prefixIcon: Container(
                              padding: const EdgeInsets.only(left: 12, right: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.phone, size: 20),
                                  SizedBox(width: 6),
                                  Text("+60 |", style: TextStyle(fontSize: 13, color: Colors.black)),
                                ],
                              ),
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            errorMaxLines: 2,
                            errorStyle: const TextStyle(fontSize: 11, height: 1.2),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          ),
                        ),
                        required: true,
                      ),

                      const SizedBox(height: 10),

                      //Address Input Field
                      _buildLabeledField("Address", _buildTextField(
                        controller: _addressController,
                        hint: "Current Location",
                        icon: Icons.location_on,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.my_location),
                          onPressed: _locateAddress,
                        ),
                        validator: (v) => v == null || v.isEmpty ? "Required" : null,
                      ), required: true),
                      const SizedBox(height: 10),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildLabeledField("Street", _buildTextField(
                              controller: _streetController,
                              hint: "Street",
                            ))),
                            const SizedBox(width: 12),
                            Expanded(child: _buildLabeledField("Postal Code", _buildTextField(
                              controller: _postalCodeController,
                              hint: "Postal Code",
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                              value == null || value.isEmpty || !RegExp(r'^\d{5}$').hasMatch(value)
                                  ? "Enter a 5-digit postal code (e.g. 11200)"
                                  : null,
                            ), required: true)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // City Input Field
                      _buildLabeledField("City", DropdownButtonFormField<String>(
                        value: _cityController.text.isEmpty ? null : _cityController.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "City",
                          hintStyle: TextStyle(fontSize: 13),
                          isDense: true,
                          errorStyle: TextStyle(fontSize: 11, height: 1.2),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        style: TextStyle(fontSize: 14),
                        items: _malaysianCities.map((s) => DropdownMenuItem(
                          value: s, child: Text(s),
                        )).toList(),
                        onChanged: (v) => _cityController.text = v ?? '',
                        validator: (v) => v == null || v.isEmpty ? "Required" : null,
                      ), required: true),

                      const SizedBox(height: 10),

                      // State Input Field
                      _buildLabeledField("State", DropdownButtonFormField<String>(
                        value: _stateController.text.isEmpty ? null : _stateController.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "State",
                          hintStyle: TextStyle(fontSize: 13),
                          isDense: true,
                          errorStyle: TextStyle(fontSize: 11, height: 1.2),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        style: TextStyle(fontSize: 14),
                        items: _malaysianStates.map((s) => DropdownMenuItem(
                          value: s, child: Text(s),
                        )).toList(),
                        onChanged: (v) => _stateController.text = v ?? '',
                        validator: (v) => v == null || v.isEmpty ? "Required" : null,
                      ), required: true),

                      const SizedBox(height: 10),

                      // Password Input Field
                      _buildLabeledField("Password", _buildTextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        hint: "Password",
                        icon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: _togglePasswordVisibility,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,  // realtime validate
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Required";
                          if (value.length < 8) return "Min 8 characters, including alphabet, digit and special character (!@#&*~)";
                          if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#&*~]).{8,}$').hasMatch(value)) {
                            return "Must include alphabet, digit and special character (!@#&*~)";
                          }
                          return null;
                        },
                      ), required: true),
                      const SizedBox(height: 10),

                      //Confirm Password Input Field
                      _buildLabeledField("Confirm Password", _buildTextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        hint: "Confirm Password",
                        icon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,  //realtime validate
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Required";
                          if (value != _passwordController.text) return "Passwords do not match";
                          return null;
                        },
                      ), required: true),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[200],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
