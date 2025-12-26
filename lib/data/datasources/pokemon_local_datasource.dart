import 'package:hive/hive.dart';
import '../models/pokemon_model.dart';
import '../models/pokemon_detail_model.dart';

class PokemonLocalDataSource {
  const PokemonLocalDataSource(this._box, this._detailBox);

  final Box<PokemonModel> _box;
  final Box<PokemonDetailModel> _detailBox;

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

  Future<PokemonDetailModel?> getPokemonDetail(int id) async {
    try {
      return _detailBox.get(id);
    } catch (e) {
      throw CacheException('Error reading detail from cache: $e');
    }
  }

  Future<void> savePokemonDetail(PokemonDetailModel detail) async {
    try {
      await _detailBox.put(detail.id, detail);
    } catch (e) {
      throw CacheException('Error saving detail to cache: $e');
    }
  }
}

class CacheException implements Exception {
  const CacheException(this.message);
  final String message;

  @override
  String toString() => message;
}

