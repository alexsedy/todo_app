import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({Key? key}) : super(key: key);

  @override
  _GroupsWidgetState createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final model = GroupWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
      model: model,
      child: const _GroupsWidgetBody(),
    );
  }
}

class _GroupsWidgetBody extends StatelessWidget {
  const _GroupsWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
      ),
      body: const _GroupListWidget(),
      floatingActionButton: CustomFloatingActionButton(),
    );
  }
}

class _GroupListWidget extends StatefulWidget {
  const _GroupListWidget({super.key});

  @override
  State<_GroupListWidget> createState() => _GroupListWidgetState();
}
class _GroupListWidgetState extends State<_GroupListWidget> {
  @override
  Widget build(BuildContext context) {
    var groupsCount = GroupsWidgetModelProvider.watch(context)?.model.groups.length ?? 0;

    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _GroupRowWidget(indexInList: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 4,);
      },
      itemCount: groupsCount,
    );
  }
}

class _GroupRowWidget extends StatelessWidget {
  final int indexInList;
  const _GroupRowWidget({super.key, required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.read(context)!.model;
    final group = model.groups[indexInList];
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteGroup(indexInList),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(group.name),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: () => model.addGroup(context, indexInList),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: FloatingActionButton(
              onPressed: () {},
              tooltip: 'Add task',
              child: Icon(Icons.notes),
            ),
          ),
          Positioned(
            bottom: 80.0,
            right: 0.0,
            child: FloatingActionButton(
              onPressed: () => GroupsWidgetModelProvider.read(context)?.model.addGroupNote(context),
              tooltip: 'Add list',
              child: Icon(Icons.folder),
            ),
          ),
      ],
    );
  }
}

