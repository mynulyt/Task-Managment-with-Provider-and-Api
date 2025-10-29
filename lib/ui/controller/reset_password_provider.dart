import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_mngwithprovider/Data/services/api_caller.dart';
import 'package:task_mngwithprovider/Data/utils/urls.dart';

class ResetPasswordProvider extends ChangeNotifier {
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;
  String? error;

  Future<bool> reset({required String email, required String otp}) async {
    if (passCtrl.text.trim().length < 8 ||
        passCtrl.text.trim() != confirmCtrl.text.trim()) {
      error = 'Invalid password or mismatch';
      notifyListeners();
      return false;
    }

    _loading = true;
    error = null;
    notifyListeners();

    final pass = passCtrl.text.trim();
    ApiResponse res;

    // Try all variants (as previous impl)
    res = await ApiCaller.postRequest(
      url: Urls.recoverResetPasswordPost(),
      body: {"email": email, "OTP": otp, "password": pass},
    );
    if (!res.isSuccess) {
      res = await ApiCaller.postRequest(
        url: Urls.recoverResetPasswordPost(),
        body: {"email": email, "otp": otp, "password": pass},
      );
    }
    if (!res.isSuccess) {
      res = await ApiCaller.postRequest(
        url: Urls.recoverResetPasswordPost(),
        body: {"email": email, "OTP": otp, "newPassword": pass},
      );
    }
    if (!res.isSuccess) {
      res = await ApiCaller.postRequest(
        url: Urls.recoverResetPasswordPost(),
        body: {"email": email, "otp": otp, "newPassword": pass},
      );
    }

    _loading = false;

    if (res.isSuccess) {
      notifyListeners();
      return true;
    } else {
      error = res.errorMessage ?? 'Password reset failed (406)';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }
}
