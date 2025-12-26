import 'package:flutter/material.dart';
import '../../../../domain/entities/pokemon.dart';
import 'loading_indicator.dart';
import 'pokemon_card.dart';

class PokemonGrid extends StatelessWidget {
  const PokemonGrid({
    super.key,
    required this.pokemons,
    required this.hasReachedMax,
    required this.scrollController,
  });

  final List<Pokemon> pokemons;
  final bool hasReachedMax;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);

        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: hasReachedMax ? pokemons.length : pokemons.length + 1,
          itemBuilder: (context, index) {
            return index >= pokemons.length
                ? const BottomLoader()
                : PokemonCard(pokemon: pokemons[index]);
          },
        );
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1200) return 6;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }
}

