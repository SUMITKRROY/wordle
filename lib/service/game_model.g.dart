// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../data/game_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameModelAdapter extends TypeAdapter<GameModel> {
  @override
  final int typeId = 0;

  @override
  GameModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameModel(
      answerWord: fields[0] as String,
      currentGrid: (fields[1] as List).cast<List<String>>(),
      currentRow: fields[2] as int,
      currentCol: fields[3] as int,
      gameStatus: fields[4] as String,
      timerRemaining: fields[5] as int,
      isTimeMode: fields[6] as bool,
      lastPlayed: fields[7] as DateTime?,
      letterEvaluations: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.answerWord)
      ..writeByte(1)
      ..write(obj.currentGrid)
      ..writeByte(2)
      ..write(obj.currentRow)
      ..writeByte(3)
      ..write(obj.currentCol)
      ..writeByte(4)
      ..write(obj.gameStatus)
      ..writeByte(5)
      ..write(obj.timerRemaining)
      ..writeByte(6)
      ..write(obj.isTimeMode)
      ..writeByte(7)
      ..write(obj.lastPlayed)
      ..writeByte(8)
      ..write(obj.letterEvaluations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
} 