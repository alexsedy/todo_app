import 'package:flutter/material.dart';
import 'package:todo_app/ui/widget_ui/group/group_form/group_form_widget.dart';
import 'package:todo_app/ui/widget_ui/group/groups/groups_widget.dart';
import 'package:todo_app/ui/widget_ui/notes/note/notes_widget.dart';
import 'package:todo_app/ui/widget_ui/notes/note_form/note_form_widget.dart';
import 'package:todo_app/ui/widget_ui/task/task_form/task_form_widget.dart';
import 'package:todo_app/ui/widget_ui/task/tasks/tasks_widget.dart';
import 'package:todo_app/ui/widget_ui/task/tasks/tasks_widget_model.dart';

abstract class MainNavigationRoutsName{
  static const groups = "/";
  static const groupsForm = "/groupsForm";
  static const task = "/tasks";
  static const taskForm = "/tasks/form";
  static const note = "/note";
  static const noteForm = "/note/form";

}

class MainNavigation{
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRoutsName.groups: (context) => const GroupsWidget(),
    MainNavigationRoutsName.groupsForm: (context) => const GroupFormWidget(),
    MainNavigationRoutsName.note: (context) => const NoteWidget(),
    MainNavigationRoutsName.noteForm: (context) => const NoteFormWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRoutsName.task:
        final configuration = settings.arguments as TaskWidgetModelConfiguration;
        return MaterialPageRoute(
          builder: (context) => TasksWidget(configuration: configuration),
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