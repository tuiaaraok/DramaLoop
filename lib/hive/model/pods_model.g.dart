// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pods_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PodsModelAdapter extends TypeAdapter<PodsModel> {
  @override
  final int typeId = 1;

  @override
  PodsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PodsModel(
      nameOfTheProps: fields[0] as String,
      status: fields[1] as String,
      quantity: fields[2] as String,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PodsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nameOfTheProps)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PodsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
