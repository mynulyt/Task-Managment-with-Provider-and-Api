import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:task_mngwithprovider/ui/provider_controller/auth_controller.dart';

class AppBarProvider extends ChangeNotifier {
  String _fullName = '';
  String _email = '';
  Uint8List? _photoBytes;

  String get fullName => _fullName;
  String get email => _email;
  Uint8List? get photoBytes => _photoBytes;

  void hydrateFromAuth() {
    final u = AuthController.userModel;
    if (u == null) return;

    _fullName = u.fullName ?? '';
    _email = u.email;

    if ((u.photo ?? '').isNotEmpty) {
      try {
        final decoded = jsonDecode(u.photo!) as List<dynamic>;
        _photoBytes = Uint8List.fromList(decoded.cast<int>());
      } catch (_) {
        _photoBytes = null;
      }
    } else {
      _photoBytes = null;
    }

    notifyListeners();
  }

  Future<void> signOut() async {
    await AuthController.clearUserData();
    _fullName = '';
    _email = '';
    _photoBytes = null;
    notifyListeners();
  }
}
