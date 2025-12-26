import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/pokemon_list/pokemon_list_bloc.dart';
import '../../bloc/pokemon_list/pokemon_list_event.dart';
import '../../bloc/pokemon_list/pokemon_list_state.dart';
import 'widgets/error_display.dart';
import 'widgets/pokemon_grid.dart';

class PokemonListView extends StatefulWidget {
  const PokemonListView({super.key});

  @override
  State<PokemonListView> createState() => _PokemonListViewState();
}

class _PokemonListViewState extends State<PokemonListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PokemonListBloc>().add(PokemonFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
      ),
      body: BlocBuilder<PokemonListBloc, PokemonListState>(
        builder: (context, state) {
          switch (state.status) {
            case PokemonListStatus.failure:
              return ErrorDisplay(
                message: state.errorMessage,
                onRetry: () =>
                    context.read<PokemonListBloc>().add(PokemonFetched()),
              );
            case PokemonListStatus.success:
              if (state.pokemons.isEmpty) {
                return const Center(child: Text('No Pokémon encontrados'));
              }
              return PokemonGrid(
                pokemons: state.pokemons,
                hasReachedMax: state.hasReachedMax,
                scrollController: _scrollController,
              );
            case PokemonListStatus.initial:
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

