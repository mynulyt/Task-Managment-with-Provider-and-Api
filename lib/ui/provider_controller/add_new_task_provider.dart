import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_mngwithprovider/Data/services/api_caller.dart';
import 'package:task_mngwithprovider/Data/utils/urls.dart';

class AddNewTaskProvider extends ChangeNotifier {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  bool _loading = false;
  String? error;
  bool get loading => _loading;

  Future<bool> submit() async {
    _loading = true;
    error = null;
    notifyListeners();

    final body = {
      "title": titleCtrl.text.trim(),
      "description": descCtrl.text.trim(),
      "status": "New",
    };

    final res = await ApiCaller.postRequest(
      url: Urls.createTaskUrl,
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
    titleCtrl.clear();
    descCtrl.clear();
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }
}
