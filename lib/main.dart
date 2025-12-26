import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_config/database/hive_config.dart';
import 'app_config/dio_client.dart';
import 'app_config/theme/app_theme.dart';
import 'data/datasources/pokemon_local_datasource.dart';
import 'data/datasources/pokemon_remote_datasource.dart';
import 'data/repositories/pokemon_repository_impl.dart';
import 'domain/repositories/pokemon_repository.dart';
import 'presentation/pages/pokemon_list/pokemon_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveConfig.initialize();
  final pokemonBox = await HiveConfig.openPokemonBox();

  runApp(MyApp(pokemonBox: pokemonBox));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.pokemonBox});

  final pokemonBox;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PokemonRepository>(
      create: (context) => PokemonRepositoryImpl(
        PokemonLocalDataSource(pokemonBox),
        PokemonRemoteDataSource(DioClient.instance),
        Connectivity(),
      ),
      child: MaterialApp(
        title: 'Pokédex',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const PokemonListPage(),
      ),
    );
  }
}
