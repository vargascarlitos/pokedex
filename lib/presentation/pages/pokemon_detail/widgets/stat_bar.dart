import 'package:flutter/material.dart';

class PokemonStatBar extends StatelessWidget {
  const PokemonStatBar({
    super.key,
    required this.statName,
    required this.statValue,
    this.maxValue = 255,
  });

  final String statName;
  final int statValue;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (statValue / maxValue).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              _formatStatName(statName),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 45,
            child: Text(
              statValue.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getStatColor(percentage, theme.colorScheme),
                ),
                minHeight: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatName(String name) {
    const statNames = {
      'hp': 'HP',
      'attack': 'ATK',
      'defense': 'DEF',
      'special-attack': 'SP. ATK',
      'special-defense': 'SP. DEF',
      'speed': 'SPD',
    };
    return statNames[name] ?? name.toUpperCase();
  }

  Color _getStatColor(double percentage, ColorScheme colors) {
    if (percentage >= 0.7) return colors.tertiary;
    if (percentage >= 0.4) return colors.secondary;
    return colors.error;
  }
}

