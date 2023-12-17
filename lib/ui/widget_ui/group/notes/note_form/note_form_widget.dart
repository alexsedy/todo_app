import 'package:flutter/material.dart';
import 'package:todo_app/ui/widget_ui/group/notes/note/notes_widget_model.dart';

class NoteFormWidget extends StatefulWidget {
  const NoteFormWidget({super.key});

  @override
  State<NoteFormWidget> createState() => _NoteFormWidgetState();
}

class _NoteFormWidgetState extends State<NoteFormWidget> {
  final _model = NotesWidgetModel();

  @override
  Widget build(BuildContext context) {
    return NotesWidgetModelProvider(
      model: _model,
      child: const _TextFormBodyWidget(),
    );
  }
}

class _TextFormBodyWidget extends StatelessWidget {
  const _TextFormBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _model = NotesWidgetModelProvider.read(context)?.model;

    return Scaffold(
      appBar: AppBar(title: Text("Add note")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NotesWidgetModelProvider.read(context)?.model.saveNote(context),
        child: Icon(Icons.done),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: TextField(
                maxLines: 1,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontSize: 20,
                  ),
                  hintText: "Name",
                  border: InputBorder.none
                ),
                style: TextStyle(
                ),
                onChanged: (value) => _model?.header = value,
              )
            ),
            Expanded(
              child: SingleChildScrollView(
                child: TextField(
                  minLines: 1,
                  maxLines: 50,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Note",
                  ),
                  onChanged: (value) => _model?.noteBody = value,
                  onEditingComplete: () => _model?.saveNote(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}