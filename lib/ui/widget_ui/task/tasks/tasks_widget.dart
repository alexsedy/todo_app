import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/ui/widget_ui/task/tasks/tasks_widget_model.dart';

import '../task_form/task_form_widget.dart';

class TasksWidget extends StatefulWidget {
  final TaskWidgetModelConfiguration configuration;
  const TasksWidget({super.key, required this.configuration});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
      model: _model,
      child: const TasksWidgetBody());
  }
}


class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final taskModel = TasksWidgetModelProvider.watch(context)?.model;
    final title = taskModel?.configuration.title ?? "Tasks";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return TaskFormWidget(groupKey: taskModel?.configuration.groupKey ?? 0);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _TaskListWidget extends StatefulWidget {
  const _TaskListWidget({super.key});

  @override
  State<_TaskListWidget> createState() => _TaskListWidgetState();
}
class _TaskListWidgetState extends State<_TaskListWidget> {
  @override
  Widget build(BuildContext context) {
    var tasksCount = TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _TaskListRowWidget(indexInList: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 4,);
      },
      itemCount: tasksCount,
    );
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;
  const _TaskListRowWidget({super.key, required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)!.model;
    final task = model.tasks[indexInList];

    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(),
        children: [
          // SlidableAction(
          //   onPressed: (context) => (){},
          //   backgroundColor: Colors.blueGrey,
          //   foregroundColor: Colors.white,
          //   icon: Icons.more_vert,
          //   label: 'More',
          // ),
          SlidableAction(
            onPressed: (context) => model.deleteTask(indexInList),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(task.text,
          style: TextStyle(decoration: task.isDone ? TextDecoration.lineThrough : null)
        ),
        trailing: Icon(task.isDone ? Icons.check_box : Icons.check_box_outline_blank),
        onTap: () => model.doneToggle(indexInList),
      ),
    );
  }
}
