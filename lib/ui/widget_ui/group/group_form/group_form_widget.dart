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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GroupIconWidget(),
          _GroupNameWidget(),
        ],
      ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _model = GroupFormWidgetModelProvider.read(context)?.model;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        autofocus: true,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          hintText: "Group name"
        ),
        onChanged: (value) => _model?.groupName = value,
        onEditingComplete: () => _model?.saveGroup(context),
      ),
    );
  }
}

class _GroupIconWidget extends StatelessWidget {
  const _GroupIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //border: Border.all(width: 2),
        //borderRadius: BorderRadius.circular(16),
      ),
      child: PopupMenuButton<IconData>(
        onSelected: (icon) {
          // Обработчик выбора иконки
        },
        child: Stack(
          children: [
            Container(
                width: 90,
                height: 90,
                child: Card(color: Colors.deepPurple.shade100)),
            IconButton(onPressed: () {  }, icon: Icon(Icons.dashboard_customize_sharp), iconSize: 90),

          ],
        ),
        //icon: Icon(Icons.touch_app, size: 50),
        itemBuilder: (BuildContext context) {
          return IconList.iconList.map((icon) {
            return PopupMenuItem<IconData>(
              value: icon,
              child: Icon(icon),
            );
          }).toList();
        },
      ),
    );
  }
}

class IconList {
  static const List<IconData> iconList = [
    Icons.star,
    Icons.favorite,
    Icons.home,
    Icons.work,
    Icons.shopping_cart,
    Icons.access_alarm,
    Icons.attach_file,
    Icons.build,
    Icons.camera,
    Icons.directions_run,
  ];
}