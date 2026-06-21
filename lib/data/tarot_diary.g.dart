// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarot_diary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TarotDiaryAdapter extends TypeAdapter<TarotDiary> {
  @override
  final int typeId = 0;

  @override
  TarotDiary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TarotDiary(
      id: fields[0] as String,
      cardId: fields[1] as String,
      spreadType: fields[7] as String,
      myNote: fields[8] as String,
      resultText: fields[2] as String,
      date: fields[9] as DateTime,
      cardIds: (fields[3] as List).cast<String>(),
      cardReversals: (fields[4] as List).cast<bool>(),
      positionLabels: (fields[5] as List).cast<String>(),
      cardMeanings: (fields[6] as List).cast<String>(),
      witchId: fields[10] as String?,
      tags: (fields[11] as List).cast<String>(),
      followUpNote: fields[12] as String,
      followUpDate: fields[13] as DateTime?,
      isSynced: fields[14] == null ? false : fields[14] as bool,
      isPublic: fields[15] == null ? false : fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TarotDiary obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardId)
      ..writeByte(2)
      ..write(obj.resultText)
      ..writeByte(3)
      ..write(obj.cardIds)
      ..writeByte(4)
      ..write(obj.cardReversals)
      ..writeByte(5)
      ..write(obj.positionLabels)
      ..writeByte(6)
      ..write(obj.cardMeanings)
      ..writeByte(7)
      ..write(obj.spreadType)
      ..writeByte(8)
      ..write(obj.myNote)
      ..writeByte(9)
      ..write(obj.date)
      ..writeByte(10)
      ..write(obj.witchId)
      ..writeByte(11)
      ..write(obj.tags)
      ..writeByte(12)
      ..write(obj.followUpNote)
      ..writeByte(13)
      ..write(obj.followUpDate)
      ..writeByte(14)
      ..write(obj.isSynced)
      ..writeByte(15)
      ..write(obj.isPublic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TarotDiaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
