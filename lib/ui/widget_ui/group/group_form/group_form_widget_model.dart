import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/domain/entity/group_entity.dart';
import 'package:todo_app/utilites/box_manager.dart';

import '../../../../constants/constants.dart';

class GroupFormWidgetModel extends ChangeNotifier {
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

  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) return;
    final group = Group(
      name: groupName,
      iconValue: _selectedIcon,
      colorValue: _selectedColor,
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
    return old.model != model;
      // old.model.selectedIcon != model.selectedIcon ||
      //   old.model.selectedColor != model.selectedColor;
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
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.lightBlueAccent,
    Colors.deepPurpleAccent,
    Colors.deepPurple.shade300,
    Colors.purple.shade300,
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

  static List<Color> get colors => _colors;

  static IconData getIconByIndex(int index) {
    return icons[index];
  }

  static Color getColorByIndex(int index) {
    return _colors[index];
  }
}
