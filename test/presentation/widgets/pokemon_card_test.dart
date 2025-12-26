import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/domain/entities/pokemon.dart';
import 'package:pokedex/presentation/pages/pokemon_list/widgets/pokemon_card.dart';

void main() {
  group('PokemonCard Widget Tests', () {
    const testPokemon = Pokemon(
      id: 25,
      name: 'pikachu',
      imageUrl: 'https://example.com/25.png',
    );

    testWidgets('displays pokemon name and id correctly', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonCard(pokemon: testPokemon),
          ),
        ),
      );

      // Assert
      expect(find.text('PIKACHU'), findsOneWidget);
      expect(find.text('#025'), findsOneWidget);
    });

    testWidgets('contains interactive InkWell widget', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PokemonCard(pokemon: testPokemon),
          ),
        ),
      );

      // Assert: Card has tappable InkWell
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Hero), findsOneWidget);
    });
  });
}

