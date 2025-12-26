import '../entities/pokemon.dart';

abstract class PokemonRepository {
  Future<List<Pokemon>> getPokemons({
    required int limit,
    required int offset,
  });
}

