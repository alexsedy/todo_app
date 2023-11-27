import 'package:hive/hive.dart';

part 'group_entity.g.dart';

@HiveType(typeId: 1)
class Group extends HiveObject {

  @HiveField(0)
  String name;

  Group({required this.name});
}