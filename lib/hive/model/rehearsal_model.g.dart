// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rehearsal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RehearsalModelAdapter extends TypeAdapter<RehearsalModel> {
  @override
  final int typeId = 2;

  @override
  RehearsalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RehearsalModel(
      nameOfThePerformance: fields[0] as String,
      date: fields[1] as DateTime,
      time: fields[2] as String,
      chooseHall: fields[3] as String,
      listMembers: (fields[4] as List).cast<String>(),
      desription: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RehearsalModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nameOfThePerformance)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.chooseHall)
      ..writeByte(4)
      ..write(obj.listMembers)
      ..writeByte(5)
      ..write(obj.desription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RehearsalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
