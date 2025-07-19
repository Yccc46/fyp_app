

import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Access Camera Request
import 'package:flutter/services.dart'; //Restrict Vertical Screen
import 'package:firebase_core/firebase_core.dart'; //initial firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
//import 'dart:io';

// Pages
import 'Admin/admin_login_page.dart';
import 'Admin/admin_home_page.dart';
import 'Login&Register/change_password_page.dart';
import 'Login&Register/forget_password_page.dart';
import 'Login&Register/login_page.dart';
import 'Login&Register/start_page.dart';
import 'User/add_to_favorite.dart';
import 'User/classification_result_page.dart';
import 'User/feedback_page.dart';
import 'User/history_records_page.dart';
import 'User/homepage.dart';
import 'User/image_preview_page.dart';
import 'User/image_recognition_page.dart';
import 'User/profile_page.dart';
import 'User/reset_password.dart';
import 'User/settings_page.dart';
import 'User/terms _and_conditions_page.dart';
import 'Layout/web_only_page.dart';


late List<CameraDescription> cameras; // Global camera list

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );

  } catch (e) {
    print("Firebase init error: $e");
  }

  cameras = await availableCameras(); // Fetch available cameras

  // only allow vertical screen
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final designSize = kIsWeb
        ? const Size(1440, 1024)  // Web Screen
        : const Size(360, 690); // Mobile Screen
    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: kIsWeb ? const AdminLoginPage()  // Admin Platform
              : const StartTheme(), // Mobile Platform

          routes: {
            '/login': (context) => const LoginPage(),
            '/change_password': (context) => const ChangePasswordPage(),
            '/forgetPassword': (context) => const ForgetPasswordPage(),
            '/home': (context) => const HomePage(),
            '/adminHome': (context) => const AdminHomePage(),
            '/profile': (context) => const ProfilePage(),
            '/reset-password': (context) => const ResetPasswordPage(),
            '/settings': (context) => const SettingsPage(),
            '/terms': (context) => const TermsAndConditionsPage(),
            '/image-recognition': (context) => const ImageRecognitionPage(),
            '/favorite': (context) => const FavoritePage(),
            '/history': (context) => const HistoryRecordsPage(),
            '/feedback': (context) => const FeedbackPage(),
            '/webOnly': (context) => const WebOnlyPage(),
            '/preview': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
              return ImagePreviewPage(imagePath: args['imagePath']);
            },
            '/classification': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
              return ClassificationResultPage(imagePath: args['imagePath']);
            },
          },
        );
      },
    );
  }
}
