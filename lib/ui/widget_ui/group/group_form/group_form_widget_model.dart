import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/domain/entity/group_entity.dart';
import 'package:todo_app/utilites/box_manager.dart';

import '../../../../constants/constants.dart';

class GroupFormWidgetModel {
  var groupName = "";

  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) return;
    final group = Group(name: groupName);
    final box = await BoxManager.instance.openGroupBox();
    await box.add(group);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}

class GroupFormWidgetModelProvider extends InheritedWidget {
  final GroupFormWidgetModel model;

  const GroupFormWidgetModelProvider({
    super.key,
    required this.model,
    required Widget child,
  }) : super(child: child);

  static GroupFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  static GroupFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
        ?.widget;
    return widget is GroupFormWidgetModelProvider ? widget : null;
  }

  static GroupFormWidgetModelProvider of(BuildContext context) {
    final GroupFormWidgetModelProvider? result = context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
    assert(result != null, 'No GroupFormWidgetModelProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider old) {
    return false;
  }
}
