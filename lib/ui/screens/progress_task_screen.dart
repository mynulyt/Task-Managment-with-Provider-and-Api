import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mngwithprovider/ui/provider_controller/task_list_provider.dart';
import 'package:task_mngwithprovider/ui/widgets/centered_progress_indecator.dart';
import 'package:task_mngwithprovider/ui/widgets/snak_bar_message.dart';

import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressTaskListProvider>().fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<ProgressTaskListProvider>(
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
                    context.read<ProgressTaskListProvider>().fetch(),
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
            );
          },
        ),
      ),
    );
  }
}
