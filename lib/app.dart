import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/add_new_task_provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/forgot_password_otp_provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/forgot_password_provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/new_task_list_provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/reset_password_provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/sign_up_provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/task_list_provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/update_profile_provider.dart';
import 'package:task_mngwithprovider/ui/screens/login_screen.dart';
import 'package:task_mngwithprovider/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_mngwithprovider/ui/screens/sign_up_screen.dart';
import 'package:task_mngwithprovider/ui/screens/splash_screen.dart';
import 'package:task_mngwithprovider/ui/screens/update_profile_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewTaskListProvider()),
        ChangeNotifierProvider(create: (_) => UpdateProfileProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordEmailProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordOtpProvider()),
        ChangeNotifierProvider(create: (_) => AddNewTaskProvider()),
        ChangeNotifierProvider(create: (_) => ProgressTaskListProvider()),
        ChangeNotifierProvider(create: (_) => CompletedTaskListProvider()),
        ChangeNotifierProvider(create: (_) => CancelledTaskListProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigator,
        theme: ThemeData(
          colorSchemeSeed: Colors.green,
          textTheme: TextTheme(
            titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.purple,
              fixedSize: Size.fromWidth(double.maxFinite),
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        initialRoute: SplashScreen.name,
        routes: {
          SplashScreen.name: (_) => SplashScreen(),
          LoginScreen.name: (_) => LoginScreen(),
          SignUpScreen.name: (_) => SignUpScreen(),
          MainNavBarHolderScreen.name: (_) => MainNavBarHolderScreen(),
          UpdateProfileScreen.name: (_) => UpdateProfileScreen(),
        },
      ),
    );
  }
}
