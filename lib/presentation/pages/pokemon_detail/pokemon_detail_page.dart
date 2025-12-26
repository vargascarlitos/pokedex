import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/pokemon.dart';
import '../../../domain/repositories/pokemon_repository.dart';
import '../../bloc/pokemon_detail/pokemon_detail_cubit.dart';
import 'pokemon_detail_view.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({
    super.key,
    required this.pokemon,
  });

  static const String routeName = '/pokemon-detail';
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonDetailCubit(
        pokemonRepository: context.read<PokemonRepository>(),
      )..loadPokemonDetail(pokemon.id),
      child: PokemonDetailView(pokemon: pokemon),
    );
  }
}

