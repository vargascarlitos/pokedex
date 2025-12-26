import 'package:flutter/material.dart';

class MeasurementsCard extends StatelessWidget {
  const MeasurementsCard({
    super.key,
    required this.height,
    required this.weight,
  });

  final int height;
  final int weight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MeasurementItem(
              icon: Icons.height,
              label: 'Altura',
              value: '${(height / 10).toStringAsFixed(1)} m',
              theme: theme,
            ),
            Container(
              width: 1,
              height: 60,
              color: theme.colorScheme.surfaceContainerHighest,
            ),
            _MeasurementItem(
              icon: Icons.fitness_center,
              label: 'Peso',
              value: '${(weight / 10).toStringAsFixed(1)} kg',
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementItem extends StatelessWidget {
  const _MeasurementItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

