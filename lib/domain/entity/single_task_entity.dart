import 'package:hive/hive.dart';

part 'single_task_entity.g.dart';

@HiveType(typeId: 3)
class SingleTask extends HiveObject {

  @HiveField(0)
  String singleTask;

  @HiveField(1)
  bool isDone;

  SingleTask({required this.singleTask, required this.isDone});
}