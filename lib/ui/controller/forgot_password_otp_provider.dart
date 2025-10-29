import 'package:flutter/foundation.dart';
import 'package:task_mngwithprovider/Data/services/api_caller.dart';
import 'package:task_mngwithprovider/Data/utils/urls.dart';

class ForgotPasswordOtpProvider extends ChangeNotifier {
  String otp = '';
  bool _loading = false;
  String? error;
  bool get loading => _loading;

  void setOtp(String v) {
    otp = v.trim();
    notifyListeners();
  }

  Future<bool> verifyOtp(String email) async {
    if (otp.length != 6) {
      error = 'Enter 6 digit OTP';
      notifyListeners();
      return false;
    }
    _loading = true;
    error = null;
    notifyListeners();

    final res = await ApiCaller.getRequest(
      url: Urls.recoverVerifyOtpUrl(email, otp),
    );
    _loading = false;

    if (res.isSuccess) {
      notifyListeners();
      return true;
    } else {
      error = res.errorMessage ?? 'Invalid OTP';
      notifyListeners();
      return false;
    }
  }
}
