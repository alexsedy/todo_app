// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_task_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SingleTaskAdapter extends TypeAdapter<SingleTask> {
  @override
  final int typeId = 3;

  @override
  SingleTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SingleTask(
      singleTask: fields[0] as String,
      isDone: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SingleTask obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.singleTask)
      ..writeByte(1)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SingleTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
