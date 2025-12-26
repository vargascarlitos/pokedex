import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/pokemon.dart';
import '../../bloc/pokemon_detail/pokemon_detail_cubit.dart';
import '../../bloc/pokemon_detail/pokemon_detail_state.dart';
import '../pokemon_list/widgets/error_display.dart';
import 'widgets/abilities_section.dart';
import 'widgets/measurements_card.dart';
import 'widgets/stats_section.dart';
import 'widgets/types_row.dart';

class PokemonDetailView extends StatelessWidget {
  const PokemonDetailView({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _PokemonDetailAppBar(pokemon: pokemon),
          _PokemonDetailContent(pokemon: pokemon),
        ],
      ),
    );
  }
}

class _PokemonDetailAppBar extends StatelessWidget {
  const _PokemonDetailAppBar({required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          pokemon.name.toUpperCase(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primaryContainer,
              ],
            ),
          ),
          child: Hero(
            tag: 'pokemon-${pokemon.id}',
            child: CachedNetworkImage(
              imageUrl: pokemon.imageUrl,
              fit: BoxFit.contain,
              errorWidget: (context, url, error) => Icon(
                Icons.catching_pokemon,
                size: 100,
                color: theme.colorScheme.onPrimary.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PokemonDetailContent extends StatelessWidget {
  const _PokemonDetailContent({required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.pokemon != current.pokemon,
      builder: (context, state) {
        switch (state.status) {
          case PokemonDetailStatus.loading:
          case PokemonDetailStatus.initial:
            return const _LoadingContent();

          case PokemonDetailStatus.failure:
            return _ErrorContent(
              errorMessage: state.errorMessage,
              pokemonId: pokemon.id,
            );

          case PokemonDetailStatus.success:
            return _SuccessContent(pokemon: state.pokemon!);
        }
      },
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Cargando detalles...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({
    required this.errorMessage,
    required this.pokemonId,
  });

  final String? errorMessage;
  final int pokemonId;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: ErrorDisplay(
          message: errorMessage,
          onRetry: () {
            context.read<PokemonDetailCubit>().loadPokemonDetail(pokemonId);
          },
        ),
      ),
    );
  }
}

class _SuccessContent extends StatelessWidget {
  const _SuccessContent({required this.pokemon});

  final pokemon;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          TypesRow(types: pokemon.types),
          const SizedBox(height: 24),
          MeasurementsCard(
            height: pokemon.height,
            weight: pokemon.weight,
          ),
          const SizedBox(height: 24),
          StatsSection(stats: pokemon.stats),
          const SizedBox(height: 24),
          AbilitiesSection(abilities: pokemon.abilities),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}

