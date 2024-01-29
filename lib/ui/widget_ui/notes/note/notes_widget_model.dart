import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/domain/entity/note_entity.dart';
import 'package:todo_app/ui/navigation/main_navigation.dart';
import 'package:todo_app/utilities/box_manager.dart';


class NotesWidgetModel extends ChangeNotifier {
  late final Future<Box<Note>> _box;
  ValueListenable<Object>? _listenableBox;
  var _note = <Note>[];

  var header = "";
  List<Map<String, dynamic>> bodyJson = [];
  List<Map<String, dynamic>> aaaaaaaa = [{"insert" : "\n"}];

  NotesWidgetModel() {
    _setup();
  }

  List<Note> get getNote => _note.reversed.toList();

  Future<void> saveNote(BuildContext context, {Note? existingNote}) async {
    // if (header.isEmpty && bodyJson.isEmpty) {
    //   return;
    // }
    if (header.trim().isEmpty && bodyJson.first.containsValue("\n")) {
      return;
    }

    final box = await BoxManager.instance.openNoteBox();

    if (existingNote != null) {
      // Case 3: Edit existing Note header
      if (header.isNotEmpty) {
        existingNote.noteHeader = header;
        await box.put(existingNote.key, existingNote);
      }

      // Case 4: Edit existing Note noteBody
      if (bodyJson.isNotEmpty) {
        existingNote.noteBodyJson = bodyJson;
        await box.put(existingNote.key, existingNote);
      }
    } else {
      if(header.isEmpty) {
        final note = Note(noteHeader: "", noteBodyJson: bodyJson);
        await box.add(note);
      } else if (bodyJson.isEmpty) {
        final note = Note(noteHeader: header, noteBodyJson: []);
        await box.add(note);
      } else {
        final note = Note(noteHeader: header, noteBodyJson: bodyJson);
        await box.add(note);
      }
    }

    // Case 5: Edit existing Note header and noteBody
    if (existingNote != null && header.isNotEmpty && bodyJson.isNotEmpty) {
      existingNote.noteHeader = header;
      existingNote.noteBodyJson = bodyJson;
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
