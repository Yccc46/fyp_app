import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  /// Email + Password 登录
  Future<String?> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = credential.user?.uid;
      if (uid == null) return "Login failed.";

      final userDoc = await _firestore.collection('User').doc(email.trim()).get();
      if (!userDoc.exists) {
        await _auth.signOut();
        return "Account not found.";
      }

      return null; // 登录成功
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return "Account not found.";
      if (e.code == 'wrong-password') return "Wrong password.";
      return "Login failed. ${e.message}";
    } catch (e) {
      return "Unexpected error.";
    }
  }

  /// Google 登录（包含 Firestore 创建 + 地址写入）
  Future<String?> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return "Cancelled by user.";

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final uid = userCredential.user?.uid;
      final email = googleUser.email;

      if (uid == null || email.isEmpty) return "Google login failed.";

      final userDoc = await _firestore.collection('User').doc(email).get();

      if (!userDoc.exists) {
        final addressMap = await _getUserAddress();

        await _firestore.collection('User').doc(email).set({
          "Username": googleUser.displayName ?? '',
          "Email_Address": email,
          "Address": addressMap,
          "Phone_Number": null,
          "Profile_Picture": googleUser.photoUrl,
          "Google_ID": googleUser.id,
          "Login_Method": "Google Login",
          "Point": 0,
          "Created_Date": Timestamp.now(),
          "Role": "User",
        });
      }

      return null; // 登录成功
    } catch (e) {
      return "Google login failed.";
    }
  }

  /// 获取用户地址（调用定位 + 反向地理编码）
  Future<Map<String, dynamic>?> _getUserAddress() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      return {
        "Street": place.street ?? "",
        "City": place.locality ?? "",
        "State": place.administrativeArea ?? "",
        "PostalCode": place.postalCode ?? "",
      };
    } catch (e) {
      return null;
    }
  }
}
