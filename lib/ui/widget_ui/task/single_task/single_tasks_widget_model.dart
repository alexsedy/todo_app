import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../../constants/constants.dart';
import '../../../../domain/entity/single_task_entity.dart';
import '../../../navigation/main_navigation.dart';

class SingleTaskWidgetModel extends ChangeNotifier {
  var _singleTask = <SingleTask>[];
  var singleTaskText = "";

  SingleTaskWidgetModel() {
    _setup();
  }

  List<SingleTask> get singleTasks => _singleTask.toList();

  void saveSingleTask(BuildContext context) async {
    if (singleTaskText.isEmpty) return;
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(SingleTaskAdapter());
    }
    final box = await Hive.openBox<SingleTask>(BoxConstants.SingleTaskBox);
    final singleTask = SingleTask(singleTask: singleTaskText, isDone: false);
    await box.add(singleTask);
    Navigator.of(context).pop();
  }

  void addSingleTask(BuildContext context, int groupIndex) async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(SingleTaskAdapter());
    }
    final box = await Hive.openBox<SingleTask>(BoxConstants.SingleTaskBox);
    final groupKey = box.keyAt(groupIndex);

    Navigator.of(context).pushNamed(MainNavigationRoutsName.task, arguments: groupKey);
  }

  void doneToggle(int index) async {
    final task = _singleTask[index];
    final currentState = task.isDone ?? false;
    task?.isDone = !currentState;
    await task.save();
    notifyListeners();
  }

  void deleteSingleTask(int singleTaskIndex) async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(SingleTaskAdapter());
    }

    final box = await Hive.openBox<SingleTask>(BoxConstants.SingleTaskBox);
    await box.deleteAt(singleTaskIndex);
  }

  void _readSingleTaskFromHive(Box<SingleTask> box) {
    _singleTask = box.values.toList();
    notifyListeners();
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(SingleTaskAdapter());
    }
    final box = await Hive.openBox<SingleTask>(BoxConstants.SingleTaskBox);

    _readSingleTaskFromHive(box);
    box.listenable().addListener(() => _readSingleTaskFromHive(box));
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
