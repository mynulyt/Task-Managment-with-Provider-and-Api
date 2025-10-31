import 'package:flutter/material.dart';
import 'package:task_mngwithprovider/Data/services/api_caller.dart';
import 'package:task_mngwithprovider/Data/utils/urls.dart';

class SignUpProvider extends ChangeNotifier {
  final emailCtrl = TextEditingController();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool _loading = false;
  String? error;
  bool get loading => _loading;

  Future<bool> submit() async {
    _loading = true;
    error = null;
    notifyListeners();

    final body = {
      'email': emailCtrl.text.trim(),

      'firstName': firstNameCtrl.text.trim(),
      'lastName': lastNameCtrl.text.trim(),
      'mobile': mobileCtrl.text.trim(),
      'password': passwordCtrl.text,
    };

    final res = await ApiCaller.postRequest(
      url: Urls.registrationUrl,
      body: body,
    );
    _loading = false;

    if (res.isSuccess) {
      clear();
      notifyListeners();
      return true;
    } else {
      error = res.errorMessage;
      notifyListeners();
      return false;
    }
  }

  void clear() {
    emailCtrl.clear();
    firstNameCtrl.clear();
    lastNameCtrl.clear();
    mobileCtrl.clear();
    passwordCtrl.clear();
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    mobileCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}
