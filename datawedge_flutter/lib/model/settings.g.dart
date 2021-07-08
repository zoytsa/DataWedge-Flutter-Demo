// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 0;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      fields[0] as String,
      fields[1] as dynamic,
    )
      ..valueBool = fields[2] as bool
      ..valueDouble = fields[3] as double
      ..valueString = fields[4] as String
      ..valueDate = fields[5] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.valueBool)
      ..writeByte(3)
      ..write(obj.valueDouble)
      ..writeByte(4)
      ..write(obj.valueString)
      ..writeByte(5)
      ..write(obj.valueDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
