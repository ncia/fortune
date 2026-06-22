// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saju_diary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SajuDiaryAdapter extends TypeAdapter<SajuDiary> {
  @override
  final int typeId = 0;

  @override
  SajuDiary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SajuDiary(
      id: fields[0] as String,
      sajuData: fields[1] as String,
      myNote: fields[3] as String,
      resultText: fields[2] as String,
      date: fields[4] as DateTime,
      witchId: fields[5] as String?,
      tags: (fields[6] as List).cast<String>(),
      followUpNote: fields[7] as String,
      followUpDate: fields[8] as DateTime?,
      isSynced: fields[9] == null ? false : fields[9] as bool,
      isPublic: fields[10] == null ? false : fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SajuDiary obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sajuData)
      ..writeByte(2)
      ..write(obj.resultText)
      ..writeByte(3)
      ..write(obj.myNote)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.witchId)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.followUpNote)
      ..writeByte(8)
      ..write(obj.followUpDate)
      ..writeByte(9)
      ..write(obj.isSynced)
      ..writeByte(10)
      ..write(obj.isPublic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SajuDiaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
