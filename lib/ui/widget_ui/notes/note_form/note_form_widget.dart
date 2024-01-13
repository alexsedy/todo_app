import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:todo_app/domain/entity/note_entity.dart';
import 'package:todo_app/ui/widget_ui/notes/note/notes_widget_model.dart';

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
      // child: _TextFormBodyWidget(),
      child: _TextFormBodyWidget(),
    );
  }
}

class _TextFormBodyWidget extends StatelessWidget {
  _TextFormBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _model = NotesWidgetModelProvider.read(context)?.model;

    final Note? note = ModalRoute.of(context)?.settings.arguments as Note?;
    final headerController = TextEditingController(text: note?.header);
    final noteBodyController = TextEditingController(text: note?.note);

    String? html = '''<html><body></body></html>''';

    final _controller = QuillController.basic();



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
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    placeholder: "Note",
                    controller: _controller,
                    readOnly: false,
                    sharedConfigurations: const QuillSharedConfigurations(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 60, bottom: 15),
                child: QuillToolbar.simple(
                  configurations: QuillSimpleToolbarConfigurations(
                    toolbarIconAlignment: WrapAlignment.start,
                    multiRowsDisplay: false,
                    // showColorButton: false,
                    showFontSize: false,
                    showDividers: false,
                    showInlineCode: false,
                    showFontFamily: false,
                    showClearFormat: false,
                    showHeaderStyle: false,
                    showUndo: false,
                    showRedo: false,
                    showQuote: false,
                    showSubscript: false,
                    showSuperscript: false,
                    showCodeBlock: false,
                    showIndent: false,
                    showLink: false,
                    showSearchButton: false,
                    controller: _controller,
                    sharedConfigurations: const QuillSharedConfigurations(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}