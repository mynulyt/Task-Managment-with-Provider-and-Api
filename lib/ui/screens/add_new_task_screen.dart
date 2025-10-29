import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/add_new_task_provider.dart';
import 'package:task_mngwithprovider/ui/widgets/centered_progress_indecator.dart';
import 'package:task_mngwithprovider/ui/widgets/screen_background.dart';
import 'package:task_mngwithprovider/ui/widgets/snak_bar_message.dart';
import 'package:task_mngwithprovider/ui/widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: Consumer<AddNewTaskProvider>(
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
                      const SizedBox(height: 32),
                      Text(
                        'Add new task',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: p.titleCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(hintText: 'Title'),
                        validator: (v) => (v?.trim().isEmpty ?? true)
                            ? 'Enter your title'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: p.descCtrl,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                        ),
                        validator: (v) => (v?.trim().isEmpty ?? true)
                            ? 'Enter your description'
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
                              if (!mounted) return;
                              if (ok) {
                                Navigator.pop(context, true);
                              } else if (p.error != null) {
                                showSnackBarMessage(context, p.error!);
                              }
                            }
                          },
                          child: const Text('Add'),
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
