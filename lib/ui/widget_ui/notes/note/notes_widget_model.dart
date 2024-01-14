import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/domain/entity/note_entity.dart';
import 'package:todo_app/domain/entity/task_entity.dart';
import 'package:todo_app/ui/navigation/main_navigation.dart';
import 'package:todo_app/utilities/box_manager.dart';


class NotesWidgetModel extends ChangeNotifier {
  late final Future<Box<Note>> _box;
  ValueListenable<Object>? _listenableBox;
  var _note = <Note>[];
  var noteBody = "";
  var header = "";

  NotesWidgetModel() {
    _setup();
  }

  List<Note> get getNote => _note.reversed.toList();

  Future<void> saveNote(BuildContext context, {Note? existingNote}) async {
    if (header.isEmpty && noteBody.isEmpty) {
      return;
    }

    final box = await BoxManager.instance.openNoteBox();

    if (existingNote != null) {
      // Case 3: Edit existing Note header
      if (header.isNotEmpty) {
        existingNote.header = header;
        await box.put(existingNote.key, existingNote);
      }

      // Case 4: Edit existing Note noteBody
      if (noteBody.isNotEmpty) {
        existingNote.note = noteBody;
        await box.put(existingNote.key, existingNote);
      }
    } else {
      if(header.isEmpty) {
        final note = Note(header: "", note: noteBody);
        await box.add(note);
      } else if (noteBody.isEmpty) {
        final note = Note(header: header, note: "");
        await box.add(note);
      } else {
        final note = Note(header: header, note: noteBody);
        await box.add(note);
      }
    }

    // Case 5: Edit existing Note header and noteBody
    if (existingNote != null && header.isNotEmpty && noteBody.isNotEmpty) {
      existingNote.header = header;
      existingNote.note = noteBody;
      await box.put(existingNote.key, existingNote);
    }

    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }

  Future<void> addNote(BuildContext context) async {
    Navigator.of(context).pushNamed(MainNavigationRoutsName.noteForm);
  }

  Future<void> openNote(BuildContext context, Note note) async {
    Navigator.of(context).pushNamed(MainNavigationRoutsName.noteForm, arguments: note);
  }

  Future<void> deleteNote(Note note) async {
    final box = await _box;
    await box.delete(note.key);
  }

  // Future<void> deleteNote(int noteIndex) async {
  //   final box = await _box;
  //   final groupKey = box.keyAt(noteIndex) as int;
  //   await box.delete(groupKey);
  // }

  Future<void> _readNoteFromHive() async {
    _note = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openNoteBox();
    _readNoteFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readNoteFromHive);
  }
}

class NotesWidgetModelProvider extends InheritedNotifier {
  final NotesWidgetModel model;
  const NotesWidgetModelProvider({
    super.key,
    required this.model,
    required Widget child,
  }) : super(child: child, notifier: model);


  static NotesWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NotesWidgetModelProvider>();
  }

  static NotesWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<
        NotesWidgetModelProvider>()
        ?.widget;
    return widget is NotesWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(NotesWidgetModelProvider old) {
    return true;
  }
}
