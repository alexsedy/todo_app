import 'package:flutter/material.dart';
import 'package:todo_app/domain/entity/task_entity.dart';
import 'package:todo_app/utilities/box_manager.dart';


class TaskFormWidgetModel {
  int groupKey;
  var taskText = "";

  TaskFormWidgetModel({required this.groupKey});

  Future<void> saveTask(BuildContext context, Task? existingTask) async {
    if (taskText.isEmpty) return;

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

  // Future<void> saveTask(BuildContext context) async {
  //   if (taskText.isEmpty) return;
  //
  //   final groupBox = await BoxManager.instance.openGroupBox();
  //   final taskBox = await BoxManager.instance.openTaskBox();
  //
  //   final task = Task(text: taskText, isDone: false);
  //   taskBox.add(task);
  //   final group = groupBox.get(groupKey);
  //   group?.addTaskHive(taskBox, task);
  //
  //   Navigator.of(context).pop();
  // }
}

class TaskFormWidgetModelProvider extends InheritedWidget {
  final TaskFormWidgetModel model;
  const TaskFormWidgetModelProvider({
    super.key,
    required this.model,
    required Widget child,
  }) : super(child: child);

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
