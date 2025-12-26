import 'package:hive/hive.dart';
import '../models/pokemon_model.dart';

class PokemonLocalDataSource {
  const PokemonLocalDataSource(this._box);

  final Box<PokemonModel> _box;

  Future<List<PokemonModel>> getPokemons({
    required int limit,
    required int offset,
  }) async {
    try {
      final allPokemons = _box.values.toList();
      
      allPokemons.sort((a, b) => a.id.compareTo(b.id));
      
      final startIndex = offset;
      final endIndex = (offset + limit).clamp(0, allPokemons.length);
      
      if (startIndex >= allPokemons.length) {
        return [];
      }
      
      return allPokemons.sublist(startIndex, endIndex);
    } catch (e) {
      throw CacheException('Error reading from cache: $e');
    }
  }

  Future<void> savePokemons(List<PokemonModel> pokemons) async {
    try {
      final Map<int, PokemonModel> pokemonMap = {
        for (var pokemon in pokemons) pokemon.id: pokemon,
      };
      
      await _box.putAll(pokemonMap);
    } catch (e) {
      throw CacheException('Error saving to cache: $e');
    }
  }

  Future<void> clearCache() async {
    try {
      await _box.clear();
    } catch (e) {
      throw CacheException('Error clearing cache: $e');
    }
  }
}

class CacheException implements Exception {
  const CacheException(this.message);
  final String message;

  @override
  String toString() => message;
}

