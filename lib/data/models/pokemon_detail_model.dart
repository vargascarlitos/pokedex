import 'package:hive/hive.dart';
import '../../domain/entities/pokemon_detail.dart';

part 'pokemon_detail_model.g.dart';

@HiveType(typeId: 1)
class PokemonDetailModel extends HiveObject {
  PokemonDetailModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities,
    required this.cachedAt,
  });

  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  List<String> types;

  @HiveField(4)
  int height;

  @HiveField(5)
  int weight;

  @HiveField(6)
  Map<String, dynamic> stats;

  @HiveField(7)
  List<String> abilities;

  @HiveField(8)
  DateTime cachedAt;

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    return PokemonDetailModel(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['sprites']['other']['official-artwork']['front_default']
          as String,
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
      height: json['height'] as int,
      weight: json['weight'] as int,
      stats: _parseStats(json['stats'] as List),
      abilities: (json['abilities'] as List)
          .map((a) => a['ability']['name'] as String)
          .toList(),
      cachedAt: DateTime.now(),
    );
  }

  static Map<String, dynamic> _parseStats(List stats) {
    final result = <String, dynamic>{};
    for (final stat in stats) {
      result[stat['stat']['name'] as String] = stat['base_stat'] as int;
    }
    return result;
  }

  PokemonDetail toEntity() {
    return PokemonDetail(
      id: id,
      name: name,
      imageUrl: imageUrl,
      types: types,
      height: height,
      weight: weight,
      stats: Map<String, int>.from(stats),
      abilities: abilities,
    );
  }
}

