import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/ui/widget_ui/task/tasks/tasks_widget_model.dart';
import 'package:todo_app/utilites/box_manager.dart';

import '../../../../domain/entity/group_entity.dart';
import '../../../navigation/main_navigation.dart';

class GroupWidgetModel extends ChangeNotifier{
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;
  var _group = <Group>[];

  GroupWidgetModel() {
    _setup();
  }

  List<Group> get groups => _group.toList();

  void addGroupForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRoutsName.groupsForm);
  }

  Future<void> addGroup(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group != null) {
      final configuration = TaskWidgetModelConfiguration(
          groupKey: group.key, title: group.name);

      Navigator.of(context).pushNamed(MainNavigationRoutsName.task, arguments: configuration);
    }
  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
    final groupKey = box.keyAt(groupIndex) as int;
    await Hive.deleteBoxFromDisk(BoxManager.instance.makeTaskBoxName(groupKey));
    await box.delete(groupKey);
  }

  Future<void> _readGroupsFromHive() async {
    _group = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openGroupBox();
    _readGroupsFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }

  Future<int> getTasksCountForGroup(int groupIndex) async {
    final groupKey = _group[groupIndex].key;
    final box = await BoxManager.instance.openTaskBox(groupKey);
    return box.values.length;
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
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

