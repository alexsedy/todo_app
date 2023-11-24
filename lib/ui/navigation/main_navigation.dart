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
  final foutes = <String, Widget Function(BuildContext)>{
    MainNavigationRoutsName.groups: (context) => GroupsWidget(),
    MainNavigationRoutsName.groupsForm: (context) => GroupFormWidget(),
    // MainNavigationRoutsName.task: (context) => TasksWidget(),
    // MainNavigationRoutsName.taskForm: (context) => TaskFormWidget(),
  };

}