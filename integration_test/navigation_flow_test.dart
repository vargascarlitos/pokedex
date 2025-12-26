import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pokedex/app_config/database/hive_config.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/presentation/pages/pokemon_list/widgets/pokemon_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pokemon App Integration Tests', () {
    testWidgets('complete navigation flow from list to detail and back',
        (tester) async {
      // Arrange: Initialize Hive and launch app
      await HiveConfig.initialize();
      final pokemonBox = await HiveConfig.openPokemonBox();
      final detailBox = await HiveConfig.openPokemonDetailBox();

      await tester.pumpWidget(MyApp(
        pokemonBox: pokemonBox,
        detailBox: detailBox,
      ));

      // Wait for initial load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Assert: Pokemon list should be visible
      expect(find.byType(PokemonCard), findsWidgets);

      // Act: Tap on first Pokemon card
      await tester.tap(find.byType(PokemonCard).first);
      await tester.pumpAndSettle();

      // Assert: Detail page should be visible with SliverAppBar
      expect(find.byType(SliverAppBar), findsOneWidget);

      // Wait for visualization (5 seconds to see the detail screen)
      debugPrint('⏳ Waiting 5 seconds for visualization...');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Act: Navigate back
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Assert: Back to list
      expect(find.byType(PokemonCard), findsWidgets);
    });
  });
}

