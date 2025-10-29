import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:task_mngwithprovider/ui/provider_controller/auth_controller.dart';
import 'package:task_mngwithprovider/ui/screens/login_screen.dart';
import 'package:task_mngwithprovider/ui/screens/update_profile_screen.dart';

class AppBarProvider extends ChangeNotifier {
  String get fullName => AuthController.userModel?.fullName ?? '';
  String get email => AuthController.userModel?.email ?? '';

  Uint8List? get photoBytes {
    final raw = AuthController.userModel?.photo;
    if (raw == null || raw.isEmpty) return null;
    try {
      return base64Decode(raw);
    } catch (_) {
      return null;
    }
  }

  void goToUpdateProfile(
    BuildContext context, {
    bool fromUpdateProfile = false,
  }) {
    if (fromUpdateProfile) return;
    Navigator.pushNamed(context, UpdateProfileScreen.name);
  }

  Future<void> signOut(BuildContext context) async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.name,
      (predicate) => false,
    );
  }

  void refresh() {
    notifyListeners();
  }
}
