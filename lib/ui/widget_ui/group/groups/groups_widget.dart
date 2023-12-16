import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/ui/widget_ui/task/single_task_form/single_task_form_widget.dart';
import 'package:todo_app/ui/widget_ui/task/tasks/tasks_widget_model.dart';

import '../../task/single_task/single_task_widget.dart';
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


class _GroupsWidgetBody extends StatefulWidget {
  const _GroupsWidgetBody({Key? key}) : super(key: key);

  @override
  State<_GroupsWidgetBody> createState() => _GroupsWidgetBodyState();
}

class _GroupsWidgetBodyState extends State<_GroupsWidgetBody> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _GroupGridWidget(),
    const SingleTaskWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
      ),
      floatingActionButton: CustomFloatingActionButton(index: _currentIndex),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_copy_outlined),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.toc),
            label: 'Tasks',
          ),
        ],
      ),
    );
  }
}

class _GroupGridWidget extends StatefulWidget {
  const _GroupGridWidget({super.key});

  @override
  State<_GroupGridWidget> createState() => _GroupGridWidgetState();
}

class _GroupGridWidgetState extends State<_GroupGridWidget> {
  @override
  Widget build(BuildContext context) {
    var groupsCount = GroupsWidgetModelProvider.watch(context)?.model.groups.length ?? 0;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, ),
      itemBuilder: (BuildContext context, int index) {
        return _GroupRowWidget(indexInList: index);
      },
      itemCount: groupsCount,
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

class _GroupCardWidget extends StatelessWidget {
  final int indexInList;
  const _GroupCardWidget({super.key, required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.read(context)!.model;
    final group = model.groups[indexInList];

    return GridTile(
      header: Text(group.name),
      child: Container(),
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
    final count = model.getTasksCountForGroup(indexInList);

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
      child: Card(
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 14),
              Container(child: Icon(Icons.access_alarm, size: 40,)),
              Container(height: 34),
              Text(
                group.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Container(height: 6),
              Text("$count Tasks", style: const TextStyle(fontWeight: FontWeight.w300),),
            ],
          ),
          onTap: () => model.addGroup(context, indexInList),
        ),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  int index;
  CustomFloatingActionButton({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (index == 1)
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SingleTaskFormWidget();
                },
              );
            },
            tooltip: 'Add task',
            child: Icon(Icons.notes),
          ),
        if (index == 0)
          FloatingActionButton(
            onPressed: () => GroupsWidgetModelProvider.read(context)?.model.addGroupForm(context),
            tooltip: 'Add list',
            child: Icon(Icons.folder),
          ),
      ],
    );
  }
}

