import 'package:flutter/material.dart';
import 'type_badge.dart';

class TypesRow extends StatelessWidget {
  const TypesRow({super.key, required this.types});

  final List<String> types;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: types.map((type) => PokemonTypeBadge(type: type)).toList(),
    );
  }
}

