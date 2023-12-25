import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/ui/widget_ui/group/group_form/group_form_widget_model.dart';
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

    return Scaffold(
      //appBar: AppBar(title: Text(title)),
      body: CustomScrollView(
        slivers: [
          _HeaderList(model: taskModel),
          _TaskListWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return TaskFormWidget(groupKey: taskModel?.configuration.groupKey ?? 0);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _HeaderList extends StatelessWidget {
  final TasksWidgetModel? model;

  const _HeaderList({super.key, required this.model,});

  @override
  Widget build(BuildContext context) {
    var tasks = model?.group?.tasks?.length ?? 0;


    return SliverAppBar(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      backgroundColor: IconAndColorComponent.getColorByIndex(model?.group?.colorValue ?? 0),
      expandedHeight: 340,
      floating: false,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        title: Text(model?.configuration.title ?? "Task"),
        background: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 70),
                child: CircleAvatar(
                  maxRadius: 36,
                  backgroundColor: Colors.white,
                  child: Icon(
                    IconAndColorComponent.getIconByIndex(model?.group?.iconValue ?? 0),
                    size: 50,)
                ),
              ),
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(left: 72),
                child: Text(
                  tasks ==1 ? "$tasks Task" : "$tasks Tasks",
                  style: const TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
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

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return _TaskListRowWidget(indexInList: index);
        },
        childCount: tasksCount,
      ),
    );
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;
  const _TaskListRowWidget({super.key, required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)!.model;
    final task = model.sortedTasks[indexInList];

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => (){},
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            icon: Icons.more_vert,
            label: 'More',
          ),
          SlidableAction(
            onPressed: (context) => model.deleteTask(task),
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
        onTap: () => model.doneToggle(task),
      ),
    );
  }
}