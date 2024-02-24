import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/domain/entity/task_entity.dart';
import 'package:todo_app/ui/widget_ui/task/tasks/tasks_widget.dart';
import 'package:todo_app/ui/widget_ui/task/tasks/tasks_widget_model.dart';
import 'package:todo_app/utilities/box_manager.dart';

import '../../../../domain/entity/group_entity.dart';
import '../../../navigation/main_navigation.dart';

class GroupWidgetModel extends ChangeNotifier{
  late final Future<Box<Group>> _groupBox;
  late final Future<Box<Task>> _taskBox;
  ValueListenable<Object>? _listenableBox;
  var _group = <Group>[];

  String? errorText;
  String groupName = "";
  int _selectedIcon = 0;
  int _selectedColor = 0;

  int get selectedIcon => _selectedIcon;

  set selectedIcon(int value) {
    _selectedIcon = value;
    notifyListeners();
  }

  int get selectedColor => _selectedColor;

  set selectedColor(int value) {
    _selectedColor = value;
    notifyListeners();
  }

  void saveGroup(BuildContext context, {Group? existingGroup}) async {
    if (groupName.trim().isEmpty) {
      errorText = "Please enter name";
      notifyListeners();
      return;
    }

    final box = await BoxManager.instance.openGroupBox();

    if (existingGroup != null) {
      existingGroup.name = groupName;
      existingGroup.iconValue = _selectedIcon;
      existingGroup.colorValue = _selectedColor;

      await box.put(existingGroup.key, existingGroup);

      Navigator.of(context).pop();
    } else {
      final group = Group(
        name: groupName,
        iconValue: _selectedIcon,
        colorValue: _selectedColor,
      );

      await box.add(group);

      final configuration = TaskWidgetModelConfiguration(
          groupKey: group.key, title: group.name);
      Navigator.of(context).popAndPushNamed(MainNavigationRoutsName.tasks, arguments: configuration);
    }

    await BoxManager.instance.closeBox(box);
  }

  GroupWidgetModel() {
    _setup();
  }

  List<Group> get correctGroups => _group.reversed.toList();

  List<Group> get groups => _group.reversed.toList();

  void addGroupForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRoutsName.groupsForm);
  }

  Future<void> openGroup(BuildContext context, Group group) async {
    final configuration = TaskWidgetModelConfiguration(
        groupKey: group.key, title: group.name);

    Navigator.of(context).pushNamed(MainNavigationRoutsName.tasks, arguments: configuration);
  }

  Future<void> deleteGroup(Group group) async {
    await group.tasks?.deleteAllFromHive();
    await group.delete();
  }

  Future<void> editGroup(Group group, BuildContext context) async {
    Navigator.of(context).pushNamed(MainNavigationRoutsName.groupsForm, arguments: group);
  }

  Future<void> _readGroupsFromHive() async {
    _group = (await _groupBox).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _groupBox = BoxManager.instance.openGroupBox();
    _taskBox = BoxManager.instance.openTaskBox();
    _readGroupsFromHive();
    _listenableBox = (await _groupBox).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }

  int completedTasks(Group group) {
    notifyListeners();
    return group.tasks?.where((task) => task.isDone).length ?? 0;
  }

  int uncompletedTasks(Group group) {
    notifyListeners();
    return group.tasks?.where((task) => !task.isDone).length ?? 0;
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instance.closeBox((await _groupBox));
    await BoxManager.instance.closeBox((await _taskBox));
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

  @override
  bool updateShouldNotify(GroupsWidgetModelProvider old) {
    return old.model.selectedIcon != model.selectedIcon ||
        old.model.selectedColor != model.selectedColor;
  }
}

abstract class IconAndColorComponent {
  static const icons = [
    Icons.notes,
    Icons.sunny_snowing,
    Icons.restaurant_outlined,
    Icons.access_alarm,
    Icons.ac_unit,
    Icons.smart_display_outlined,
    Icons.photo,
    Icons.bubble_chart,
    Icons.attach_money_outlined,
    Icons.edit_document,
    Icons.account_balance_wallet_outlined,
    Icons.airplane_ticket_outlined,
    Icons.account_circle_outlined,
    Icons.add_alert_outlined,
    Icons.add_location_outlined,
    Icons.assistant_outlined,
    Icons.attach_file_outlined,
    Icons.audiotrack_outlined,
    Icons.beach_access_outlined,
    Icons.bolt_outlined,
    Icons.book_outlined,
    Icons.border_color_outlined,
    Icons.business_center_outlined,
    Icons.cake_outlined,
    Icons.calendar_month_outlined,
    Icons.castle_outlined,
    Icons.catching_pokemon_outlined,
    Icons.cleaning_services_outlined,
    Icons.coffee_outlined,
    Icons.color_lens_outlined,
    Icons.computer_outlined,
    Icons.deck_outlined,
    Icons.delivery_dining_outlined,
    Icons.description_outlined,
    Icons.developer_mode_outlined,
    Icons.directions_bike_outlined,
    Icons.directions_car_filled_outlined,
    Icons.directions_walk,
    Icons.diversity_3_outlined,
    Icons.downhill_skiing_outlined,
    Icons.drafts_outlined,
    Icons.eco_outlined,
    Icons.email_outlined,
    Icons.emergency_outlined,
    Icons.emoji_emotions_outlined,
    Icons.emoji_objects_outlined,
    Icons.event,
    Icons.explore_outlined,
    Icons.extension_outlined,
    Icons.family_restroom_outlined,
    Icons.favorite_border,
    Icons.feedback_outlined,
    Icons.flatware,
    Icons.flight,
    Icons.forest_outlined,
    Icons.gamepad_outlined,
    Icons.golf_course_outlined,
    Icons.groups_2_outlined,
    Icons.headphones_outlined,
    Icons.help_outline_outlined,
    Icons.hiking_outlined,
    Icons.home_outlined,
    Icons.icecream_outlined,
    Icons.kitchen_outlined,
    Icons.language,
    Icons.laptop,
    Icons.light_mode_outlined,
    Icons.liquor,
    Icons.local_florist_outlined,
    Icons.local_grocery_store_outlined,
    Icons.local_mall_outlined,
    Icons.local_movies,
    Icons.luggage_outlined,
    Icons.medication_outlined,
    Icons.mood_bad,
    Icons.movie_outlined,
    Icons.nightlife,
    Icons.outdoor_grill,
    Icons.park_outlined,
    Icons.pets,
    Icons.privacy_tip_outlined,
    Icons.push_pin_outlined,
    Icons.rocket_launch_outlined,
    Icons.school_outlined,
    Icons.science_outlined,
    Icons.search,
    Icons.self_improvement,
    Icons.sentiment_neutral_rounded,
    Icons.sentiment_very_dissatisfied_outlined,
    Icons.sentiment_very_satisfied_outlined,
    Icons.shopify,
    Icons.shopping_cart_outlined,
    Icons.sports_basketball_outlined,
    Icons.sports_esports_outlined,
    Icons.star_border,
    Icons.theaters_outlined,
    Icons.wine_bar,
    Icons.work_outline,
  ];

  static final List<Color> _colors = [
    Colors.blueAccent.shade100,
    Colors.lightBlue.shade100,
    Colors.lightBlueAccent.shade100,
    Colors.deepPurpleAccent.shade200,
    Colors.deepPurple.shade300,
    Colors.purple.shade300,
    Colors.red.shade300,
    Colors.redAccent.shade200,
    Colors.deepOrange.shade400,
    Colors.amber.shade200,
    Colors.amberAccent.shade200,
    Colors.yellow.shade200,
    Colors.green.shade400,
    Colors.greenAccent.shade400,
    Colors.lightGreen.shade400,
    Colors.lightGreenAccent.shade200,
    Colors.lime.shade400,
    Colors.limeAccent.shade400,
    Colors.blueGrey.shade400,
    Colors.black12,
    Colors.grey.shade400,
  ];

  // static final List<Color> _colors = [
  //   Colors.blueAccent,
  //   Colors.lightBlue,
  //   Colors.lightBlueAccent,
  //   Colors.deepPurpleAccent,
  //   Colors.deepPurple.shade300,
  //   Colors.purple.shade300,
  //   Colors.red,
  //   Colors.redAccent,
  //   Colors.deepOrange,
  //   Colors.amber,
  //   Colors.amberAccent,
  //   Colors.yellow,
  //   Colors.green,
  //   Colors.greenAccent,
  //   Colors.lightGreen,
  //   Colors.lightGreenAccent,
  //   Colors.lime,
  //   Colors.limeAccent,
  //   Colors.blueGrey,
  //   Colors.black12,
  //   Colors.grey,
  // ];

  static List<Color> get colors => _colors;

  static IconData getIconByIndex(int index) {
    return icons[index];
  }

  static Color getColorByIndex(int index) {
    return _colors[index];
  }
}