import 'package:flutter/material.dart';
import '../../../../domain/entities/pokemon.dart';
import '../../../widgets/pokemon_network_image.dart';
import '../../pokemon_detail/pokemon_detail_page.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDetailPage(pokemon: pokemon),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Hero(
                  tag: 'pokemon-${pokemon.id}',
                  child: PokemonNetworkImage(
                    imageUrl: pokemon.imageUrl,
                    fit: BoxFit.contain,
                    memCacheWidth: 200,
                    memCacheHeight: 200,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '#${pokemon.id.toString().padLeft(3, '0')}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                pokemon.name.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

