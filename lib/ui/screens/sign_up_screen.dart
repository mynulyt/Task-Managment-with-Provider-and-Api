import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/sign_up_provider.dart';
import 'package:task_mngwithprovider/ui/widgets/centered_progress_indecator.dart';
import 'package:task_mngwithprovider/ui/widgets/screen_background.dart';
import 'package:task_mngwithprovider/ui/widgets/snak_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String name = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Consumer<SignUpProvider>(
          builder: (_, p, __) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 82),
                      Text(
                        'Join With Us',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: p.emailCtrl,
                        decoration: const InputDecoration(hintText: 'Email'),
                        validator: (v) => EmailValidator.validate(v ?? '')
                            ? null
                            : 'Enter a valid Email',
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: p.firstNameCtrl,
                        decoration: const InputDecoration(
                          hintText: 'First name',
                        ),
                        validator: (v) => (v?.trim().isEmpty ?? true)
                            ? 'Enter a first name'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: p.lastNameCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Last name',
                        ),
                        validator: (v) => (v?.trim().isEmpty ?? true)
                            ? 'Enter a last name'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: p.mobileCtrl,
                        decoration: const InputDecoration(hintText: 'Mobile'),
                        validator: (v) => (v?.trim().isEmpty ?? true)
                            ? 'Enter a phone number'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: p.passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Password'),
                        validator: (v) => ((v?.length ?? 0) <= 6)
                            ? 'Password shuld more than 6 letter'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: p.loading == false,
                        replacement: const CenteredProgressIndecator(),
                        child: FilledButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final ok = await p.submit();
                              if (ok) {
                                if (mounted) {
                                  showSnackBarMessage(
                                    context,
                                    'Registration Success! Please login',
                                  );
                                }
                                if (mounted) Navigator.pop(context);
                              } else if (p.error != null) {
                                if (mounted) {
                                  showSnackBarMessage(context, p.error!);
                                }
                              }
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Icon(Icons.arrow_circle_right_outlined),
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
                                  ..onTap = () => Navigator.pop(context),
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
          },
        ),
      ),
    );
  }
}
