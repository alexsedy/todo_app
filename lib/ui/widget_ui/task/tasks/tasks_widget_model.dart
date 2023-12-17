import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/domain/entity/group_entity.dart';
import 'package:todo_app/domain/entity/task_entity.dart';
import 'package:todo_app/utilites/box_manager.dart';

import '../../../navigation/main_navigation.dart';

class TasksWidgetModel extends ChangeNotifier{
  final TaskWidgetModelConfiguration configuration;
  late final Future<Box<Task>> _taskBox;
  late final Future<Box<Group>> _groupBox;
  ValueListenable<Object>? _listenableBox;
  var _tasks = <Task>[];
  Group? _group;

  List<Task> get tasks => _tasks.toList();

  Group? get group => _group;

  TasksWidgetModel({required this.configuration}) {
    _setup();
  }

  Future<void> _setup() async {
    _taskBox = BoxManager.instance.openTaskBox();
    _groupBox = BoxManager.instance.openGroupBox();
    await _readTasksFromHive();
    _listenableBox = (await _taskBox).listenable();
    _listenableBox?.addListener(_readTasksFromHive);
  }

  Future<void> _readTasksFromHive() async {
    final box = await _groupBox;
    _group = box.get(configuration.groupKey);

    _tasks = _group?.tasks ?? <Task>[];

    notifyListeners();
  }

  void addTask(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRoutsName.taskForm, arguments: configuration.groupKey);
  }

  Future<void> deleteTask(int taskIndex) async {
    await _group?.tasks?.deleteFromHive(taskIndex);
    await _group?.save();
  }

  Future<void> doneToggle(int taskIndex) async {
    final task = group?.tasks?[taskIndex];
    final currentState = task?.isDone ?? false;
    task?.isDone = !currentState;
    await task?.save();
    notifyListeners();
  }

  @override
  void dispose() async {
    _listenableBox?.removeListener(_readTasksFromHive);
    await BoxManager.instance.closeBox((await _taskBox));
    await BoxManager.instance.closeBox((await _groupBox));
    super.dispose();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;
  const TasksWidgetModelProvider({
    super.key,
    required Widget child,
    required this.model
  }) : super(child: child, notifier: model);

  static TasksWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  static TasksWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }
}

class TaskWidgetModelConfiguration {
  final int groupKey;
  final String title;

  TaskWidgetModelConfiguration({required this.groupKey, required this.title});
}
