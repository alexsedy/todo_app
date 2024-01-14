import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/ui/widget_ui/notes/note/notes_widget_model.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({super.key});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  final noteModel = NotesWidgetModel();

  @override
  Widget build(BuildContext context) {
    return NotesWidgetModelProvider(
      model: noteModel,
      child: _NotesListWidget(),
    );
  }
}

class _NotesListWidget extends StatefulWidget {
  const _NotesListWidget({super.key});

  @override
  State<_NotesListWidget> createState() => _GroupListWidgetState();
}
class _GroupListWidgetState extends State<_NotesListWidget> {
  @override
  Widget build(BuildContext context) {
    var groupsCount = NotesWidgetModelProvider.watch(context)?.model.getNote.length ?? 0;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return _NotesRowWidget(indexInList: index);
      },
      itemCount: groupsCount,
    );
  }
}


class _NotesRowWidget extends StatelessWidget {
  final int indexInList;
  const _NotesRowWidget({super.key, required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = NotesWidgetModelProvider.read(context)!.model;
    final note = model.getNote[indexInList];
    final isEmptyHeader = model.getNote[indexInList].header.isEmpty;

    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(),
        children: [
          Container(
            height: 190,
            width: 100,
            child: SlidableAction(
              autoClose: true,
              borderRadius: BorderRadius.circular(12),
              onPressed: (context) => model.deleteNote(note),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Card(
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(!isEmptyHeader) Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  note.header,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
                Container(height: 10),
                Text(
                  note.note,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: null,
            onTap: () => model.openNote(context, note),
          ),
        ),
      ),
    );
  }
}



