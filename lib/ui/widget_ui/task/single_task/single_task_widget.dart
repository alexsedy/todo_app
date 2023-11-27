import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/ui/widget_ui/task/single_task/single_tasks_widget_model.dart';

class SingleTaskWidget extends StatefulWidget {
  const SingleTaskWidget({super.key});

  @override
  State<SingleTaskWidget> createState() => _SingleTaskWidgetState();
}

class _SingleTaskWidgetState extends State<SingleTaskWidget> {
  final singleTaskModel = SingleTaskWidgetModel();

  @override
  Widget build(BuildContext context) {
    return SingleTaskWidgetModelProvider(
      model: singleTaskModel,
      child: _SingleTaskListWidget(),
    );
  }
}

class _SingleTaskListWidget extends StatefulWidget {
  const _SingleTaskListWidget({super.key});

  @override
  State<_SingleTaskListWidget> createState() => _SingleTaskListWidgetState();
}

class _SingleTaskListWidgetState extends State<_SingleTaskListWidget> {
  @override
  Widget build(BuildContext context) {
    var itemCount = SingleTaskWidgetModelProvider.watch(context)?.model.singleTasks.length ?? 0;

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
          return _SingleTaskRowWidget(indexInList: index);
        },
      // separatorBuilder: (BuildContext context, int index) {
      //     return const Divider(height: 4,);
      //   },
      itemCount: itemCount);
  }
}


class _SingleTaskRowWidget extends StatelessWidget {
  final int indexInList;
  const _SingleTaskRowWidget({super.key, required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = SingleTaskWidgetModelProvider.read(context)!.model;
    final singleTask = model.singleTasks[indexInList];

    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteSingleTask(indexInList),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: singleTask.isDone ? Colors.grey : Colors.deepPurple.shade200,
              width: 2)
          ),
          child: ListTile(
            title: Text(singleTask.singleTask,
                style: TextStyle(decoration: singleTask.isDone ? TextDecoration.lineThrough : null)
            ),
            trailing: Icon(singleTask.isDone ? Icons.check_box : Icons.check_box_outline_blank),
            onTap: () => model.doneToggle(indexInList),
          ),
        ),
      ),
    );
  }
}



