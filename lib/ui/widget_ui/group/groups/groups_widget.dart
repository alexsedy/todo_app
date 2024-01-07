import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/ui/widget_ui/group/group_form/group_form_widget_model.dart';
import 'package:todo_app/ui/widget_ui/notes/note/notes_widget.dart';
import 'package:todo_app/ui/widget_ui/notes/note/notes_widget_model.dart';

import 'groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({Key? key}) : super(key: key);

  @override
  _GroupsWidgetState createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final groupModel = GroupWidgetModel();
  final noteModel = NotesWidgetModel();

  @override
  Widget build(BuildContext context) {
    return NotesWidgetModelProvider(
      model: noteModel,
      child: GroupsWidgetModelProvider(
        model: groupModel,
        child: const _GroupsWidgetBody(),
      ),
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
    const NoteWidget(),
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
            icon: Icon(Icons.check_box_rounded),
            label: 'To Do',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Notes',
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, ),
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

class _GroupRowWidget extends StatelessWidget {
  final int indexInList;
  const _GroupRowWidget({super.key, required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.read(context)!.model;
    final group = model.groups[indexInList];
    final iconIndex = model.groups[indexInList].iconValue;
    final colorIndex = model.groups[indexInList].colorValue;
    var completed = model.completedTasks(group);
    var uncompleted = model.uncompletedTasks(group);

    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(),
        children: [
          SizedBox(
            height: 195,
            width: 50,
            child: SlidableAction(
              onPressed: (context) => model.deleteGroup(group),
              autoClose: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              borderRadius: BorderRadius.circular(12),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              //label: 'Delete',
            ),
          ),
          SizedBox(
            height: 195,
            width: 50,
            child: SlidableAction(
              onPressed: (context) => model.editGroup(group, context),
              autoClose: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              borderRadius: BorderRadius.circular(12),
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              //label: 'Delete',
            ),
          ),
        ],
      ),
      child: Card(
        //color: IconAndColorComponent.getColorByIndex(colorIndex),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 14),
              Container(
                child: Icon(
                  IconAndColorComponent.getIconByIndex(iconIndex),
                  size: 40,
                  color: IconAndColorComponent.getColorByIndex(colorIndex),)),
              Container(height: 34),
              Text(
                group.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Container(height: 6),
              Text("$completed completed", style: const TextStyle(fontWeight: FontWeight.w300),),
              Text("$uncompleted uncompleted", style: const TextStyle(fontWeight: FontWeight.w300),),
            ],
          ),
          onTap: () => model.openGroup(context, group),
        ),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final int index;
  CustomFloatingActionButton({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: index == 1
          ? FloatingActionButton(
        key: ValueKey<int>(index),
        onPressed: () => NotesWidgetModelProvider.read(context)?.model.addNote(context),
        tooltip: 'Add note',
        child: Icon(Icons.notes),
      )
          : FloatingActionButton(
        key: ValueKey<int>(index),
        onPressed: () => GroupsWidgetModelProvider.read(context)?.model.addGroupForm(context),
        tooltip: 'Add list',
        child: Icon(Icons.folder),
      ),
    );
  }
}
