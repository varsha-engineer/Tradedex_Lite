import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthProvider extends ChangeNotifier {
  final LocalAuthentication _auth = LocalAuthentication();

  bool isLoggedIn = false;
  bool biometricAvailable = false;

  AuthProvider() {
    checkBiometric();
  }

  /// 🔍 Check if device supports biometrics
  Future<void> checkBiometric() async {
    try {
      biometricAvailable = await _auth.canCheckBiometrics;
      notifyListeners();
    } catch (e) {
      biometricAvailable = false;
    }
  }

  ///  Normal Login
  Future<bool> login(String email, String password) async {
    if (email.isNotEmpty && password.length >= 4) {
      isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// BIOMETRIC LOGIN (FINGERPRINT + FACE)
  Future<bool> biometricLogin() async {
    try {
      final isAvailable = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();

      if (!isAvailable || !isDeviceSupported) return false;

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Authenticate to access TradeX Lite',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        isLoggedIn = true;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("Biometric Error: $e");
    }

    return false;
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }
}
