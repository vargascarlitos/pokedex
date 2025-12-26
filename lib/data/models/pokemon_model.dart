import 'package:hive/hive.dart';
import '../../domain/entities/pokemon.dart';

part 'pokemon_model.g.dart';

@HiveType(typeId: 0)
class PokemonModel extends HiveObject {
  PokemonModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cachedAt,
  });

  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  DateTime cachedAt;

  factory PokemonModel.fromJson(Map<String, dynamic> json, int id) {
    return PokemonModel(
      id: id,
      name: json['name'] as String,
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      cachedAt: DateTime.now(),
    );
  }

  factory PokemonModel.fromMap(Map<String, dynamic> map) {
    return PokemonModel(
      id: map['id'] as int,
      name: map['name'] as String,
      imageUrl: map['image_url'] as String,
      cachedAt: DateTime.parse(map['cached_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'cached_at': cachedAt.toIso8601String(),
    };
  }

  Pokemon toEntity() {
    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
    );
  }
}

