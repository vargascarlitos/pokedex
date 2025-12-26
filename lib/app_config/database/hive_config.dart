import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/pokemon_model.dart';

class HiveConfig {
  HiveConfig._();

  static const String pokemonBoxName = 'pokemons';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(PokemonModelAdapter());
  }

  static Future<Box<PokemonModel>> openPokemonBox() async {
    return await Hive.openBox<PokemonModel>(pokemonBoxName);
  }
}

