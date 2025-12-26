// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_detail_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonDetailModelAdapter extends TypeAdapter<PokemonDetailModel> {
  @override
  final int typeId = 1;

  @override
  PokemonDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonDetailModel(
      id: fields[0] as int,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      types: (fields[3] as List).cast<String>(),
      height: fields[4] as int,
      weight: fields[5] as int,
      stats: (fields[6] as Map).cast<String, dynamic>(),
      abilities: (fields[7] as List).cast<String>(),
      cachedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonDetailModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.types)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.weight)
      ..writeByte(6)
      ..write(obj.stats)
      ..writeByte(7)
      ..write(obj.abilities)
      ..writeByte(8)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

