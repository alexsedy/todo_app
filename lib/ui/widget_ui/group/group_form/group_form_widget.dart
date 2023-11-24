import 'package:flutter/material.dart';
import 'package:todo_app/ui/widget_ui/group/group_form/group_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({super.key});

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupFormWidgetModelProvider(
      model: _model,
      child: const _GroupFormBodyWidget()
    );
  }
}

class _GroupFormBodyWidget extends StatelessWidget {
  const _GroupFormBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add list"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GroupFormWidgetModelProvider.read(context)?.model.saveGroup(context),
        child: Icon(Icons.done),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _GroupNameWidget(),
        ),
      ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _model = GroupFormWidgetModelProvider.read(context)?.model;
    return TextField(
      autofocus: true,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        hintText: "Name"
      ),
      onChanged: (value) => _model?.groupName = value,
      onEditingComplete: () => _model?.saveGroup(context),
    );
  }
}
