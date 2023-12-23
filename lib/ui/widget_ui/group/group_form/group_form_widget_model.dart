import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/domain/entity/group_entity.dart';
import 'package:todo_app/utilites/box_manager.dart';

import '../../../../constants/constants.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  String groupName = "";
  int selectedIcon = 0;
  int selectedColor = 0;

  // int get getSelectedIcon {
  //   return selectedIcon;
  // }
  //
  // set setSelectedIcon(int value) {
  //   selectedIcon = value;
  //   notifyListeners();
  // }
  //
  // void setSelectedColor(int index) {
  //   selectedColor = index;
  //   notifyListeners();
  // }

  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) return;
    final group = Group(
      name: groupName,
      iconValue: selectedIcon,
      colorValue: selectedColor,
    );
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
    return old.model.selectedIcon != model.selectedIcon ||
        old.model.selectedColor != model.selectedColor;
  }
}

abstract class IconAndColorComponent {
  static const icons = [
    Icons.notes,
    Icons.sunny_snowing,
    Icons.account_balance,
    Icons.access_alarm,
    Icons.account_balance,
    Icons.dashboard_customize_sharp,
    Icons.access_alarm,
    Icons.account_balance,
    Icons.dashboard_customize_sharp,
    Icons.access_alarm,
    Icons.account_balance,
    Icons.account_balance,
    Icons.dashboard_customize_sharp,
    Icons.access_alarm,
    Icons.account_balance,
    Icons.dashboard_customize_sharp,
    Icons.access_alarm,
    Icons.account_balance,
    Icons.access_alarm,
    Icons.account_balance,
    Icons.account_balance,
    Icons.dashboard_customize_sharp,
    Icons.access_alarm,
    Icons.account_balance,
    Icons.dashboard_customize_sharp,
    Icons.access_alarm,
    Icons.account_balance,
  ];

  static const colors = [
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.lightBlueAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.purple,
    Colors.red,
    Colors.redAccent,
    Colors.deepOrange,
    Colors.amber,
    Colors.amberAccent,
    Colors.yellow,
    Colors.green,
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.lime,
    Colors.limeAccent,
    Colors.blueGrey,
    Colors.black12,
    Colors.grey,
  ];

  static IconData getIconByIndex(int index) {
    return icons[index];
  }

  static Color getColorByIndex(int index) {
    return colors[index];
  }
}
