import 'package:flutter/foundation.dart';
import 'package:task_mngwithprovider/Data/model/task_model.dart';
import 'package:task_mngwithprovider/Data/services/api_caller.dart';
import 'package:task_mngwithprovider/Data/utils/urls.dart';

abstract class BaseTaskListProvider extends ChangeNotifier {
  bool _loading = false;
  String? error;
  List<TaskModel> items = [];
  bool get loading => _loading;

  String get endpoint; // override

  Future<void> fetch() async {
    _loading = true;
    error = null;
    notifyListeners();

    final res = await ApiCaller.getRequest(url: endpoint);
    if (res.isSuccess) {
      try {
        final list = <TaskModel>[];
        for (final Map<String, dynamic> e in res.responseData['data']) {
          list.add(TaskModel.fromJson(e));
        }
        items = list;
      } catch (e) {
        error = 'Parse error: $e';
      }
    } else {
      error = res.errorMessage;
    }

    _loading = false;
    notifyListeners();
  }
}

class ProgressTaskListProvider extends BaseTaskListProvider {
  @override
  String get endpoint => Urls.progressTaskListUrl;
}

class CompletedTaskListProvider extends BaseTaskListProvider {
  @override
  String get endpoint => Urls.completedTaskListUrl;
}

class CancelledTaskListProvider extends BaseTaskListProvider {
  @override
  String get endpoint => Urls.cancelledTaskListUrl;
}
