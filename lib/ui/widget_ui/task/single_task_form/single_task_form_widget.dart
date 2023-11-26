import 'package:flutter/material.dart';
import 'package:todo_app/ui/widget_ui/task/single_task/single_tasks_widget_model.dart';

class SingleTaskFormWidget extends StatefulWidget {
  const SingleTaskFormWidget({super.key,});

  @override
  State<SingleTaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<SingleTaskFormWidget> {
  late final SingleTaskWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = SingleTaskWidgetModel();
  }


  @override
  Widget build(BuildContext context) {
    return SingleTaskWidgetModelProvider(
      model: _model,
      child: const _TextFormBodyWidget(),);
  }
}

class _TextFormBodyWidget extends StatelessWidget {
  const _TextFormBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _model = SingleTaskWidgetModelProvider.read(context)?.model;

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
                onChanged: (value) => _model?.singleTaskText = value,
                onEditingComplete: () => _model?.saveSingleTask(context),
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
                      onPressed: () => _model?.saveSingleTask(context),
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