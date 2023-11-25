import 'package:flutter/material.dart';

import '../widget_ui/group/group_form/group_form_widget.dart';
import '../widget_ui/group/groups/groups_widget.dart';
import '../widget_ui/task/task_form/task_form_widget.dart';
import '../widget_ui/task/tasks/tasks_widget.dart';

abstract class MainNavigationRoutsName{
  static const groups = "/";
  static const groupsForm = "/groupsForm";
  static const task = "/tasks";
  static const taskForm = "/tasks/form";

}

class MainNavigation{
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRoutsName.groups: (context) => GroupsWidget(),
    MainNavigationRoutsName.groupsForm: (context) => GroupFormWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRoutsName.task:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => TasksWidget(groupKey: groupKey),
        );
      case MainNavigationRoutsName.taskForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) {
            return TaskFormWidget(groupKey: groupKey);
          },
        );
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}