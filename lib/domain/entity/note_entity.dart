import 'package:hive/hive.dart';

part 'note_entity.g.dart';

@HiveType(typeId: 3)
class Note extends HiveObject {

  @HiveField(0)
  String header;

  @HiveField(1)
  String note;

  Note({required this.header, required this.note});
}