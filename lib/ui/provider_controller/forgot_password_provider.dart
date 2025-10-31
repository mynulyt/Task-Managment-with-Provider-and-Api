import 'package:flutter/material.dart';
import 'package:task_mngwithprovider/Data/services/api_caller.dart';
import 'package:task_mngwithprovider/Data/utils/urls.dart';

class ForgotPasswordEmailProvider extends ChangeNotifier {
  final emailCtrl = TextEditingController();
  bool _loading = false;
  String? error;
  bool get loading => _loading;

  Future<bool> sendOtp() async {
    _loading = true;
    error = null;
    notifyListeners();

    final email = emailCtrl.text.trim();
    final res = await ApiCaller.getRequest(
      url: Urls.recoverVerifyEmailUrl(email),
    );

    _loading = false;

    if (res.isSuccess) {
      notifyListeners();
      return true;
    } else {
      error = res.errorMessage ?? 'Failed to send OTP';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }
}
