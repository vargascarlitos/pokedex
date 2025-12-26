import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/pokemon_model.dart';
import '../../data/models/pokemon_detail_model.dart';

class HiveConfig {
  HiveConfig._();

  static const String pokemonBoxName = 'pokemons';
  static const String pokemonDetailBoxName = 'pokemon_details';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(PokemonModelAdapter());
    Hive.registerAdapter(PokemonDetailModelAdapter());
  }

  static Future<Box<PokemonModel>> openPokemonBox() async {
    return await Hive.openBox<PokemonModel>(pokemonBoxName);
  }

  static Future<Box<PokemonDetailModel>> openPokemonDetailBox() async {
    return await Hive.openBox<PokemonDetailModel>(pokemonDetailBoxName);
  }
}

