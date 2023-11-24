import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/ui/widget_ui/task/tasks/tasks_widget_model.dart';

class TasksWidget extends StatefulWidget {
  final int groupKey;
  const TasksWidget({super.key, required this.groupKey});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;

  //получение ключа новый вараинт
  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(groupKey: widget.groupKey);
  }

  //получение ключа старый вариант
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   if (_model == null) {
  //     final groupKey = ModalRoute.of(context)!.settings.arguments as int;
  //     _model = TasksWidgetModel(groupKey: groupKey);
  //   }
  // }

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
    final model = TasksWidgetModelProvider.watch(context)?.model;
    final title = model?.group?.name ?? "Tasks";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.addTask(context),
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
    var groupsCount = TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _TaskListRowWidget(indexInList: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 4,);
      },
      itemCount: groupsCount,
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

    final icon = task.isDone ? Icons.check_box : Icons.check_box_outline_blank;

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
