import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../../constants/constants.dart';
import '../../../../domain/entity/group_entity.dart';
import '../../../../domain/entity/task_entity.dart';
import '../../../navigation/main_navigation.dart';

class GroupWidgetModel extends ChangeNotifier{
  var _group = <Group>[];

  GroupWidgetModel() {
    _setup();
  }

  List<Group> get groups => _group.toList();

  void addGroupNote(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRoutsName.groupsForm);
  }

  void addGroup(BuildContext context, int groupIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>(BoxConstants.GroupBox);
    final groupKey = box.keyAt(groupIndex);

    Navigator.of(context).pushNamed(MainNavigationRoutsName.task, arguments: groupKey);

  }

  void deleteGroup(int groupIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }

    final box = await Hive.openBox<Group>(BoxConstants.GroupBox);
    await box.getAt(groupIndex)?.tasks?.deleteAllFromHive();
    await box.deleteAt(groupIndex);
  }

  void _readGroupsFromHive(Box<Group> box) {
    _group = box.values.toList();
    notifyListeners();
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>(BoxConstants.GroupBox);
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox(BoxConstants.TaskBox);

    _readGroupsFromHive(box);
    box.listenable().addListener(() => _readGroupsFromHive(box));
  }

}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupWidgetModel model;
  const GroupsWidgetModelProvider({
    super.key,
    required this.model,
    required Widget child,
  }) : super(child: child, notifier: model);

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()?.widget;
    return widget is GroupsWidgetModelProvider? widget : null;
  }
}

