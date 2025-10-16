// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TemplateAdapter extends TypeAdapter<Template> {
  @override
  final int typeId = 1;

  @override
  Template read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Template(
      descrption: fields[2] as String,
      name: fields[0] as String,
      numbers: (fields[1] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Template obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.numbers)
      ..writeByte(2)
      ..write(obj.descrption);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
