// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordCardAdapter extends TypeAdapter<WordCard> {
  @override
  final int typeId = 0;

  @override
  WordCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordCard(
      word: fields[0] as String,
      translation: fields[1] as String,
      category: fields[2] as String,
      lastReviewed: fields[3] as DateTime,
      correctAnswers: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WordCard obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.translation)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.lastReviewed)
      ..writeByte(4)
      ..write(obj.correctAnswers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
