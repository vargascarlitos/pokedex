import 'package:equatable/equatable.dart';

class PokemonDetail extends Equatable {
  const PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities,
  });

  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final Map<String, int> stats;
  final List<String> abilities;

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        types,
        height,
        weight,
        stats,
        abilities,
      ];
}

