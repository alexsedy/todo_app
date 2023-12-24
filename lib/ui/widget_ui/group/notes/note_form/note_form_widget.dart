import 'package:flutter/material.dart';
import 'package:todo_app/domain/entity/note_entity.dart';
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
      child: _TextFormBodyWidget(),
    );
  }
}

class _TextFormBodyWidget extends StatelessWidget {
  const _TextFormBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _model = NotesWidgetModelProvider.read(context)?.model;

    final Note? note = ModalRoute.of(context)?.settings.arguments as Note?;
    final headerController = TextEditingController(text: note?.header);
    final noteBodyController = TextEditingController(text: note?.note);

    return Scaffold(
      appBar: AppBar(title: const Text("Add note")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NotesWidgetModelProvider.read(context)?.model.saveNote(context, existingNote: note),
        child: const Icon(Icons.done),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Center(
                child: TextField(
                  controller: headerController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 22,
                    ),
                    hintText: "Name",
                    border: InputBorder.none
                  ),
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                  onChanged: (value) => _model?.header = value,
                )
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: TextField(
                    controller: noteBodyController,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 50,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Note",
                    ),
                    onChanged: (value) => _model?.noteBody = value,
                    onEditingComplete: () => _model?.saveNote(context, existingNote: note),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.format_list_numbered)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.format_list_bulleted_rounded)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.abc_outlined)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz_outlined)),
                  Container(width: 50,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}