import 'package:flutter/material.dart';
import 'package:task_mngwithprovider/Data/model/user_model.dart';
import 'package:task_mngwithprovider/Data/utils/urls.dart';
import 'package:task_mngwithprovider/data/services/api_caller.dart';
import 'package:task_mngwithprovider/ui/provider_controller/auth_controller.dart';

class LoginProvider extends ChangeNotifier {
  bool _loginInProgress = false;

  String? _errorMessage;

  bool get loginInprogress => _loginInProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    bool isSuccess = false;

    _loginInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {"email": email, "password": password};
    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );
    if (response.isSuccess && response.responseData['status'] == 'success') {
      UserModel model = UserModel.fromJson(response.responseData['data']);
      String token = response.responseData['token'];

      await AuthController.saveUserData(model, token);

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _loginInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
