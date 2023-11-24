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

  //получение ключа новый вараинт
  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   if (_model == null) {
  //     final groupKey = ModalRoute.of(context)!.settings.arguments as int;
  //     _model = TaskFormWidgetModel(groupKey: groupKey);
  //   }
  // }


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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add tasks"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => TaskFormWidgetModelProvider.read(context)?.model.addTask(context),
        child: const Icon(Icons.done),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _TaskTextWidget(),
        ),
      ),
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _model = TaskFormWidgetModelProvider.read(context)?.model;

    return TextField(
      autofocus: true,
      textInputAction: TextInputAction.newline,
      minLines: 1,
      maxLines: 16,
      decoration: const InputDecoration(
        hintText: "Task"
      ),
      onChanged: (value) => _model?.taskText = value,
      onEditingComplete: () => _model?.addTask(context),
    );
  }
}


