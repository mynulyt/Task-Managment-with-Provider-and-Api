import 'package:flutter/material.dart';
import 'package:task_managerapi/Data/model/task_model.dart';
import 'package:task_managerapi/Data/utils/urls.dart';
import 'package:task_managerapi/ui/widgets/centered_progress_indecator.dart';
import 'package:task_managerapi/ui/widgets/snak_bar_message.dart';

import '../../data/services/api_caller.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTaskInProgress = false;
  List<TaskModel> _completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllCompletedTasks();
  }

  Future<void> _getAllCompletedTasks() async {
    _getCompletedTaskInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.completedTaskListUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getCompletedTaskInProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Visibility(
          visible: _getCompletedTaskInProgress == false,
          replacement: CenteredProgressIndecator(),
          child: ListView.separated(
            itemCount: _completedTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: _completedTaskList[index],
                refreshParent: () {
                  _getAllCompletedTasks();
                },
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 8),
          ),
        ),
      ),
    );
  }
}
