import 'package:flutter/material.dart';
import 'package:task_managerapi/Data/model/task_model.dart';
import 'package:task_managerapi/Data/services/api_caller.dart';
import 'package:task_managerapi/Data/utils/urls.dart';
import 'package:task_managerapi/ui/widgets/snak_bar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskModel,
    required this.refreshParent,
  });

  final TaskModel taskModel;
  final VoidCallback refreshParent;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _operationInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Colors.white,
        title: Text(widget.taskModel.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(widget.taskModel.description),
            SizedBox(height: 4),
            Text(
              'Date: ${widget.taskModel.createdDate}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(widget.taskModel.status),
                  backgroundColor: Colors.purpleAccent,
                  labelStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                Spacer(),
                _operationInProgress
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Row(
                        children: [
                          IconButton(
                            onPressed: _showDeleteDialog,
                            icon: Icon(Icons.delete, color: Colors.grey),
                          ),
                          IconButton(
                            onPressed: _showChangeStatusDialog,
                            icon: Icon(Icons.edit, color: Colors.grey),
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Change Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['New', 'Progress', 'Cancelled', 'Completed']
              .map(
                (status) => ListTile(
                  onTap: () => _changeStatus(status),
                  title: Text(status),
                  trailing: widget.taskModel.status == status
                      ? Icon(Icons.done)
                      : null,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> _changeStatus(String status) async {
    if (status == widget.taskModel.status) return;

    Navigator.pop(context);
    setState(() => _operationInProgress = true);

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.updateTaskStatusUrl(widget.taskModel.id, status),
    );

    setState(() => _operationInProgress = false);

    if (response.isSuccess) {
      widget.refreshParent();
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteTask();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTask() async {
    setState(() => _operationInProgress = true);

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.deleteTaskUrl(widget.taskModel.id),
    );

    setState(() => _operationInProgress = false);

    if (response.isSuccess) {
      widget.refreshParent();
      showSnackBarMessage(context, 'Task deleted successfully');
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
  }
}
