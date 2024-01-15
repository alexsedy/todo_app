import 'package:hive/hive.dart';

part 'note_entity.g.dart';

@HiveType(typeId: 3)
class Note extends HiveObject {

  @HiveField(0)
  String noteHeader;

  @HiveField(1)
  List<Map<String, dynamic>> noteBodyJson;

  Note({required this.noteHeader, required this.noteBodyJson});
}