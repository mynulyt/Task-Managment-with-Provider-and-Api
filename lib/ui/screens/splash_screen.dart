import 'package:flutter/material.dart';

import 'package:task_managerapi/ui/screens/login_screen.dart';
import 'package:task_managerapi/ui/utils/asset_paths.dart';
import 'package:task_managerapi/ui/widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, LoginScreen.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(child: Image.asset(AssetPaths.logoSvg)),
      ),
    );
  }
}
