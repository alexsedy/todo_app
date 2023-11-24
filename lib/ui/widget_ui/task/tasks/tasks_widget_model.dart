import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/domain/entity/group_entity.dart';
import 'package:todo_app/domain/entity/task_entity.dart';

import '../../../navigation/main_navigation.dart';

class TasksWidgetModel extends ChangeNotifier{
  int groupKey;
  late final Future<Box<Group>> _groupBox;

  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();

  Group? _group;
  Group? get group => _group;

  TasksWidgetModel({required this.groupKey}) {
    _setup();
  }

  void _setup() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
   _groupBox = Hive.openBox(BoxConstants.GroupBox);

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    Hive.openBox(BoxConstants.TaskBox);

   _loadGroup();

    _setupListenTask();
  }

  void _setupListenTask() async {
    final box = await _groupBox;
    _readTasksFromHive();
    box.listenable(keys: <dynamic>[groupKey]).addListener(_readTasksFromHive);
  }

  void _loadGroup() async {
    final box = await _groupBox;
    _group = box.get(groupKey);
    notifyListeners();
  }

  void _readTasksFromHive() {
    _tasks = _group?.tasks ?? <Task>[];
    notifyListeners();
  }

  void addTask(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRoutsName.taskForm, arguments: groupKey);
  }

  void deleteTask(int index) async {
    await _group?.tasks?.deleteFromHive(index);
    await _group?.save();
  }

  void doneToggle(int index) async {
    final task = group?.tasks?[index];
    final currentState = task?.isDone ?? false;
    task?.isDone = !currentState;
    await task?.save();
    notifyListeners();
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
