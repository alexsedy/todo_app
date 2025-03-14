import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/domain/entity/group_entity.dart';
import 'package:todo_app/domain/entity/task_entity.dart';

class TaskFormWidgetModel {
  int groupKey;
  var taskText = "";

  TaskFormWidgetModel({required this.groupKey});

  void addTask(BuildContext context) async {
    if(taskText.isEmpty) return;

    if(!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }

    if(!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }

    final taskBox = await Hive.openBox(BoxConstants.TaskBox);
    final task = Task(text: taskText, isDone: false);
    await taskBox.add(task);

    final groupBox = await Hive.openBox<Group>(BoxConstants.GroupBox);
    final group = groupBox.get(groupKey);
    group?.addTask(taskBox, task);

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
