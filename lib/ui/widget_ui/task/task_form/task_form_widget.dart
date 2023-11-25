import 'package:flutter/material.dart';
import 'package:todo_app/ui/widget_ui/task/task_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;
  const TaskFormWidget({super.key, required this.groupKey});

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
  }


  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
      model: _model,
      child: const _TextFormBodyWidget(),);
  }
}

class _TextFormBodyWidget extends StatelessWidget {
  const _TextFormBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _model = TaskFormWidgetModelProvider.read(context)?.model;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autofocus: true,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 16,
                decoration: const InputDecoration(
                  hintText: "Task",
                ),
                onChanged: (value) => _model?.taskText = value,
                onEditingComplete: () => _model?.saveTask(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.cancel_outlined)),
                  IconButton(
                      onPressed: () => TaskFormWidgetModelProvider.read(context)?.model.saveTask(context),
                      icon: Icon(Icons.done)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



