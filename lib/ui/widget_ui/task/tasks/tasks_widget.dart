import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/ui/widget_ui/group/groups/groups_widget_model.dart';
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


class TasksWidgetBody extends StatefulWidget {
  const TasksWidgetBody({super.key});

  @override
  State<TasksWidgetBody> createState() => _TasksWidgetBodyState();
}

class _TasksWidgetBodyState extends State<TasksWidgetBody> {
  final ScrollController _scrollController = ScrollController();
  double opacity = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    double offset = _scrollController.offset;

    if (offset <= 50) {
      setState(() {
        opacity = 1;
      });
    } else if(offset <= 100) {
      setState(() {
        opacity = 0.5;
      });
    } else if (offset <= 150) {
      setState(() {
        opacity = 0.2;
      });
    } else if (offset <= 200) {
      setState(() {
        opacity = 0.1;
      });
    } else if (offset >= 270) {
      setState(() {
        opacity = 0.0;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final taskModel = TasksWidgetModelProvider.watch(context)?.model;

    return Scaffold(
      //appBar: AppBar(title: Text(title)),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _HeaderList(model: taskModel, opacity: opacity),
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
  final double opacity;

  const _HeaderList({super.key, required this.model, required this.opacity});

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
        collapseMode: CollapseMode.pin,
        title: Text(model?.configuration.title ?? "Task"),
        background: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Opacity(
            opacity: opacity,
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

    final doneDecor = BoxDecoration(
      border: Border.all(width: 2, color: IconAndColorComponent.getColorByIndex(model.group?.colorValue ?? 0)),
      borderRadius: BorderRadius.circular(12),
    );

    final unDoneDecor = BoxDecoration(
      color: Colors.grey.shade300,
      border: Border.all(width: 2, color: Colors.grey),
      borderRadius: BorderRadius.circular(12),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(12),
              onPressed: (context) => (){},
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              icon: Icons.more_vert,
              label: 'More',
            ),
            SlidableAction(
              borderRadius: BorderRadius.circular(12),
              onPressed: (context) => model.deleteTask(task),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          decoration: task.isDone ? unDoneDecor : doneDecor,
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(task.isDone ? Icons.check_box : Icons.check_box_outline_blank,
                    color: IconAndColorComponent.getColorByIndex(model.group?.colorValue ?? 0),
                    size: 35,
                  ),
                ),
                onTap: () => model.doneToggle(task),
              ),
              //SizedBox(width: 16),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 336,
                  child: Text(
                    task.text,
                    style: TextStyle(
                        decoration: task.isDone ? TextDecoration.lineThrough : null,
                        fontSize: 22
                    ),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return TaskFormWidget(
                        groupKey: model.configuration.groupKey,
                        task: task,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    // return Slidable(
    //   endActionPane: ActionPane(
    //     motion: const ScrollMotion(),
    //     children: [
    //       SlidableAction(
    //         onPressed: (context) => (){},
    //         backgroundColor: Colors.blueGrey,
    //         foregroundColor: Colors.white,
    //         icon: Icons.more_vert,
    //         label: 'More',
    //       ),
    //       SlidableAction(
    //         onPressed: (context) => model.deleteTask(task),
    //         backgroundColor: Colors.redAccent,
    //         foregroundColor: Colors.white,
    //         icon: Icons.delete,
    //         label: 'Delete',
    //       ),
    //     ],
    //   ),
    //   child: ListTile(
    //     title: Text(task.text,
    //       style: TextStyle(decoration: task.isDone ? TextDecoration.lineThrough : null)
    //     ),
    //     trailing: Icon(task.isDone ? Icons.check_box : Icons.check_box_outline_blank),
    //     onTap: () => model.doneToggle(task),
    //   ),
    // );
  }
}
