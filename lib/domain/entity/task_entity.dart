import 'package:hive_flutter/adapters.dart';

part 'task_entity.g.dart';

@HiveType(typeId: 2)
class Task extends HiveObject{
  @HiveField(0)
  String text;

  @HiveField(1)
  bool isDone;

  Task({required this.text, required this.isDone});
}