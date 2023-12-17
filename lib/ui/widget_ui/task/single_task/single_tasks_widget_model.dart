import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/utilites/box_manager.dart';

import '../../../../domain/entity/single_task_entity.dart';
import '../../../navigation/main_navigation.dart';

class SingleTaskWidgetModel extends ChangeNotifier {
  late final Future<Box<SingleTask>> _box;
  ValueListenable<Object>? _listenableBox;
  var _singleTask = <SingleTask>[];
  var singleTaskText = "";

  SingleTaskWidgetModel() {
    _setup();
  }

  List<SingleTask> get singleTasks => _singleTask.toList();

  Future<void> saveSingleTask(BuildContext context) async {
    if (singleTaskText.isEmpty) return;
    final singleTask = SingleTask(singleTask: singleTaskText, isDone: false);
    final box = await BoxManager.instance.openSingleTaskBox();
    await box.add(singleTask);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }

  Future<void> addSingleTask(BuildContext context, int groupIndex) async {
    final groupKey = (await _box).keyAt(groupIndex) as int;

    Navigator.of(context).pushNamed(MainNavigationRoutsName.task, arguments: groupKey);
  }

  Future<void> doneToggle(int singleTaskIndex) async {
    final box = await _box;
    final task = box.getAt(singleTaskIndex);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  Future<void> deleteSingleTask(int singleTaskIndex) async {
    final box = await _box;
    final groupKey = box.keyAt(singleTaskIndex) as int;
    await box.delete(groupKey);
  }

  Future<void> _readSingleTaskFromHive() async {
    _singleTask = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openSingleTaskBox();
    _readSingleTaskFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readSingleTaskFromHive);
  }
}

class SingleTaskWidgetModelProvider extends InheritedNotifier {
  final SingleTaskWidgetModel model;
  const SingleTaskWidgetModelProvider({
    super.key,
    required this.model,
    required Widget child,
  }) : super(child: child, notifier: model);


  static SingleTaskWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SingleTaskWidgetModelProvider>();
  }

  static SingleTaskWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<
        SingleTaskWidgetModelProvider>()
        ?.widget;
    return widget is SingleTaskWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(SingleTaskWidgetModelProvider old) {
    return true;
  }
}
