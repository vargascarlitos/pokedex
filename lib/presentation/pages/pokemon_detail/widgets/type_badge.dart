import 'package:flutter/material.dart';

class PokemonTypeBadge extends StatelessWidget {
  const PokemonTypeBadge({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: typeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: typeColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        type.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return const Color(0xFFFF9C54);
      case 'water':
        return const Color(0xFF4D90D5);
      case 'grass':
        return const Color(0xFF63BB5B);
      case 'electric':
        return const Color(0xFFF3D23B);
      case 'psychic':
        return const Color(0xFFFA7179);
      case 'ice':
        return const Color(0xFF74CEC0);
      case 'dragon':
        return const Color(0xFF0A6DC4);
      case 'dark':
        return const Color(0xFF5A5465);
      case 'fairy':
        return const Color(0xFFEC8FE6);
      case 'normal':
        return const Color(0xFF9099A1);
      case 'fighting':
        return const Color(0xFFCE4069);
      case 'flying':
        return const Color(0xFF8FA8DD);
      case 'poison':
        return const Color(0xFFAB6AC8);
      case 'ground':
        return const Color(0xFFD97746);
      case 'rock':
        return const Color(0xFFC7B78B);
      case 'bug':
        return const Color(0xFF90C12C);
      case 'ghost':
        return const Color(0xFF5269AC);
      case 'steel':
        return const Color(0xFF5A8EA1);
      default:
        return const Color(0xFF9099A1);
    }
  }
}

