import 'package:flutter/material.dart';
import 'package:task_managerapi/Data/model/task_model.dart';
import 'package:task_managerapi/Data/utils/urls.dart';
import 'package:task_managerapi/ui/widgets/centered_progress_indecator.dart';
import 'package:task_managerapi/ui/widgets/snak_bar_message.dart';

import '../../data/services/api_caller.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTaskInProgress = false;
  List<TaskModel> _cancelledTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllCancelledTasks();
  }

  Future<void> _getAllCancelledTasks() async {
    _getCancelledTaskInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.cancelledTaskListUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getCancelledTaskInProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Visibility(
          visible: _getCancelledTaskInProgress == false,
          replacement: CenteredProgressIndecator(),
          child: ListView.separated(
            itemCount: _cancelledTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: _cancelledTaskList[index],
                refreshParent: () {
                  _getAllCancelledTasks();
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
