import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:todo_app/domain/entity/task_entity.dart';
import 'package:todo_app/utilites/box_manager.dart';

class TaskFormWidgetModel {
  int groupKey;
  var taskText = "";

  TaskFormWidgetModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;

    final task = Task(text: taskText, isDone: false);
    final taskBox = await BoxManager.instance.openTaskBox(groupKey);
    await taskBox.add(task);

    final groupBox = await BoxManager.instance.openGroupBox();
    groupBox.get(groupKey)?.addTaskHive(taskBox, task);

    await BoxManager.instance.closeBox(taskBox);
    await BoxManager.instance.closeBox(groupBox);

    Navigator.of(context).pop();
  }
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
