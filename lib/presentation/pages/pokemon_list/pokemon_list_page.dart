import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/pokemon_repository.dart';
import '../../bloc/pokemon_list/pokemon_list_bloc.dart';
import '../../bloc/pokemon_list/pokemon_list_event.dart';
import 'pokemon_list_view.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  static const String routeName = '/pokemon-list';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonListBloc(
        pokemonRepository: context.read<PokemonRepository>(),
      )..add(PokemonFetched()),
      child: const PokemonListView(),
    );
  }
}

