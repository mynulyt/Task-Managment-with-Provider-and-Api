import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/task_list_provider.dart';
import 'package:task_mngwithprovider/ui/widgets/centered_progress_indecator.dart';
import 'package:task_mngwithprovider/ui/widgets/snak_bar_message.dart';

import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompletedTaskListProvider>().fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<CompletedTaskListProvider>(
          builder: (_, p, __) {
            if (p.loading) return const CenteredProgressIndecator();
            if (p.error != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) showSnackBarMessage(context, p.error!);
              });
            }
            return ListView.separated(
              itemCount: p.items.length,
              itemBuilder: (_, i) => TaskCard(
                taskModel: p.items[i],
                refreshParent: () =>
                    context.read<CompletedTaskListProvider>().fetch(),
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
            );
          },
        ),
      ),
    );
  }
}
