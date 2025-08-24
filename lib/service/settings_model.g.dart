// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../data/settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 1;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      isDarkMode: fields[0] as bool,
      isTimeModeEnabled: fields[1] as bool,
      isSoundEnabled: fields[2] as bool,
      isVibrationEnabled: fields[3] as bool,
      gamesPlayed: fields[4] as int,
      gamesWon: fields[5] as int,
      bestScore: fields[6] as int,
      averageAttempts: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.isDarkMode)
      ..writeByte(1)
      ..write(obj.isTimeModeEnabled)
      ..writeByte(2)
      ..write(obj.isSoundEnabled)
      ..writeByte(3)
      ..write(obj.isVibrationEnabled)
      ..writeByte(4)
      ..write(obj.gamesPlayed)
      ..writeByte(5)
      ..write(obj.gamesWon)
      ..writeByte(6)
      ..write(obj.bestScore)
      ..writeByte(7)
      ..write(obj.averageAttempts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
} 