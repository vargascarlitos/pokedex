import 'package:flutter/material.dart';
import 'stat_bar.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key, required this.stats});

  final Map<String, int> stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas Base',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...stats.entries.map(
              (entry) => PokemonStatBar(
                statName: entry.key,
                statValue: entry.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

