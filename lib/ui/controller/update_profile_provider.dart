import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TextEditingController;
import 'package:image_picker/image_picker.dart';
import 'package:task_mngwithprovider/Data/model/user_model.dart';
import 'package:task_mngwithprovider/Data/services/api_caller.dart';
import 'package:task_mngwithprovider/Data/utils/urls.dart';
import 'package:task_mngwithprovider/ui/controller/auth_controller.dart';

class UpdateProfileProvider extends ChangeNotifier {
  final emailCtrl = TextEditingController();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;

  bool _loading = false;
  bool get loading => _loading;

  String? error;

  void hydrateFromAuth() {
    final u = AuthController.userModel!;
    emailCtrl.text = u.email;
    firstNameCtrl.text = u.firstName;
    lastNameCtrl.text = u.lastName;
    mobileCtrl.text = u.mobile;
  }

  Future<void> pickImage() async {
    selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  Future<bool> submit() async {
    _loading = true;
    error = null;
    notifyListeners();

    final body = <String, dynamic>{
      "email": emailCtrl.text,
      "firstName": firstNameCtrl.text.trim(),
      "lastName": lastNameCtrl.text.trim(),
      "mobile": mobileCtrl.text.trim(),
    };
    if (passwordCtrl.text.isNotEmpty) {
      body['password'] = passwordCtrl.text;
    }

    String? encodedPhoto;
    if (selectedImage != null) {
      final bytes = await selectedImage!.readAsBytes();
      encodedPhoto = jsonEncode(bytes);
      body['photo'] = encodedPhoto;
    }

    final res = await ApiCaller.postRequest(
      url: Urls.updateProfileUrl,
      body: body,
    );

    _loading = false;

    if (res.isSuccess) {
      passwordCtrl.clear();
      final m = UserModel(
        id: AuthController.userModel!.id,
        email: emailCtrl.text,
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        mobile: mobileCtrl.text.trim(),
        photo: encodedPhoto ?? AuthController.userModel!.photo,
      );
      await AuthController.updateUserData(m);
      notifyListeners();
      return true;
    } else {
      error = res.errorMessage;
      notifyListeners();
      return false;
    }
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
