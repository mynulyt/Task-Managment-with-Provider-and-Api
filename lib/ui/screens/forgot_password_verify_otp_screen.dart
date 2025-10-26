import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_managerapi/Data/services/api_caller.dart';
import 'package:task_managerapi/Data/utils/urls.dart';
import 'package:task_managerapi/ui/screens/login_screen.dart';
import 'package:task_managerapi/ui/screens/reset_password_screen.dart';
import 'package:task_managerapi/ui/widgets/screen_background.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordVerifyOtpScreen({super.key, required this.email});

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState
    extends State<ForgotPasswordVerifyOtpScreen> {
  String _otp = '';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 82),
              Text(
                'Enter Your OTP',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'A 6 digit OTP has been sent to ${widget.email}',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              PinCodeTextField(
                length: 6,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                appContext: context,
                onChanged: (v) => _otp = v.trim(),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _loading ? null : _verifyOtp,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Verify'),
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
    );
  }

  Future<void> _verifyOtp() async {
    final otp = _otp; // ✅ controller নেই, লোকাল স্টেট ব্যবহার

    if (otp.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter 6 digit OTP')));
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await ApiCaller.getRequest(
        url: Urls.recoverVerifyOtpUrl(widget.email, otp),
      );
      if (!mounted) return;

      if (res.isSuccess) {
        // নেভিগেশনের পরে এই স্ক্রিন dispose হবে, তাই আর UI টাচ করবো না
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(email: widget.email, otp: otp),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.errorMessage ?? 'Invalid OTP')),
        );
      }
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

  @override
  void dispose() {
    super.dispose();
  }
}
