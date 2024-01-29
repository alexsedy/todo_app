import 'package:flutter/material.dart';
import 'package:todo_app/domain/entity/task_entity.dart';
import 'package:todo_app/utilities/box_manager.dart';


class TaskFormWidgetModel extends ChangeNotifier {
  int groupKey;
  var taskText = "";
  String? errorText;

  TaskFormWidgetModel({required this.groupKey});

  Future<void> saveTask(BuildContext context, Task? existingTask) async {
    if (taskText.trim().isEmpty) {
      errorText = "Please enter a task";
      notifyListeners();

      return;
    }

    final groupBox = await BoxManager.instance.openGroupBox();
    final taskBox = await BoxManager.instance.openTaskBox();
    if (existingTask != null) {
      existingTask.text = taskText;
      taskBox.put(existingTask.key, existingTask);
    } else {
      final task = Task(text: taskText, isDone: false);
      taskBox.add(task);
      final group = groupBox.get(groupKey);
      group?.addTaskHive(taskBox, task);
    }

    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedNotifier {
  final TaskFormWidgetModel model;
  const TaskFormWidgetModelProvider({
    super.key,
    required this.model,
    required Widget child,
  }) : super(child: child, notifier: model);

  static TaskFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  static TaskFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()
        ?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider old) {
    return false;
  }
}
