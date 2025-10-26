import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_managerapi/Data/services/api_caller.dart';
import 'package:task_managerapi/Data/utils/urls.dart';
import 'package:task_managerapi/ui/screens/login_screen.dart';
import 'package:task_managerapi/ui/widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 82),
                Text(
                  'Reset Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Password should be at least 8 characters',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passCtrl,
                  decoration: const InputDecoration(hintText: 'New Password'),
                  obscureText: true,
                  validator: (v) =>
                      (v != null && v.length >= 8) ? null : 'Min 8 characters',
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Confirm New Password',
                  ),
                  obscureText: true,
                  validator: (v) =>
                      v == _passCtrl.text ? null : 'Passwords do not match',
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _loading ? null : _reset,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: const Text('Reset Password'),
                  ),
                ),
                const SizedBox(height: 36),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      text: "Already have an account? ",
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(color: Colors.green),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (r) => false,
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _reset() async {
    if (!_formKey.currentState!.validate()) return;

    final email = widget.email.trim();
    final otp = widget.otp.trim();
    final pass = _passCtrl.text.trim();

    setState(() => _loading = true);
    try {
      ApiResponse res;

      // OTP UPPERCASE
      res = await ApiCaller.postRequest(
        url: Urls.recoverResetPasswordPost(),
        body: {"email": email, "OTP": otp, "password": pass},
      );
      if (res.isSuccess) {
        return _onResetOk();
      }

      //  otp lowercase
      res = await ApiCaller.postRequest(
        url: Urls.recoverResetPasswordPost(),
        body: {"email": email, "otp": otp, "password": pass},
      );
      if (res.isSuccess) {
        return _onResetOk();
      }

      //new password key
      res = await ApiCaller.postRequest(
        url: Urls.recoverResetPasswordPost(),
        body: {"email": email, "OTP": otp, "newPassword": pass},
      );
      if (res.isSuccess) {
        return _onResetOk();
      }

      //otp and set password
      res = await ApiCaller.postRequest(
        url: Urls.recoverResetPasswordPost(),
        body: {"email": email, "otp": otp, "newPassword": pass},
      );
      if (res.isSuccess) {
        return _onResetOk();
      }

      //if failed all then showing server message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.errorMessage ?? 'Password reset failed (406)'),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onResetOk() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Password reset successful')));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (r) => false,
    );
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }
}
