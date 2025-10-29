import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mngwithprovider/ui/controller/update_profile_provider.dart';
import 'package:task_mngwithprovider/ui/widgets/centered_progress_indecator.dart';
import 'package:task_mngwithprovider/ui/widgets/screen_background.dart';
import 'package:task_mngwithprovider/ui/widgets/snak_bar_message.dart';
import 'package:task_mngwithprovider/ui/widgets/tm_app_bar.dart';
import '../widgets/photo_picker_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});
  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UpdateProfileProvider>().hydrateFromAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(fromUpdateProfile: true),
      body: ScreenBackground(
        child: Consumer<UpdateProfileProvider>(
          builder: (_, p, __) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'Update Profile',
                        style: TextTheme.of(context).titleLarge,
                      ),
                      const SizedBox(height: 24),
                      PhotoPickerField(
                        onTap: p.pickImage,
                        selectedPhoto: p.selectedImage,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: p.emailCtrl,
                        decoration: const InputDecoration(hintText: 'Email'),
                        enabled: false,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: p.firstNameCtrl,
                        decoration: const InputDecoration(
                          hintText: 'First name',
                        ),
                        validator: (v) => (v?.trim().isEmpty ?? true)
                            ? 'Enter your first name'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: p.lastNameCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Last name',
                        ),
                        validator: (v) => (v?.trim().isEmpty ?? true)
                            ? 'Enter your first name'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: p.mobileCtrl,
                        decoration: const InputDecoration(hintText: 'Mobile'),
                        validator: (v) => (v?.trim().isEmpty ?? true)
                            ? 'Enter your first name'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: p.passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password (Optional)',
                        ),
                        validator: (v) {
                          if ((v != null && v.isNotEmpty) && v.length < 6) {
                            return 'Enter a password more than 6 letters';
                          }
                          return null;
                        },
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
                                if (mounted)
                                  showSnackBarMessage(
                                    context,
                                    'Profile has been updated!',
                                  );
                              } else {
                                if (mounted && p.error != null)
                                  showSnackBarMessage(context, p.error!);
                              }
                            }
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined),
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
