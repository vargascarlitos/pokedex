import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'component_themes.dart';
import 'text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
      ),
      textTheme: AppTextStyles.textTheme,
      appBarTheme: ComponentThemes.appBarTheme,
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: ComponentThemes.filledButtonTheme,
      outlinedButtonTheme: ComponentThemes.outlinedButtonTheme,
      inputDecorationTheme: ComponentThemes.inputDecorationTheme,
      chipTheme: ComponentThemes.chipTheme,
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
      ),
      bottomNavigationBarTheme: ComponentThemes.bottomNavigationBarTheme,
      progressIndicatorTheme: ComponentThemes.progressIndicatorTheme,
    );
  }
}

/// Extension for Pokemon type colors
extension PokemonTypeColors on ThemeData {
  Color typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return AppColors.typeFire;
      case 'water':
        return AppColors.typeWater;
      case 'grass':
        return AppColors.typeGrass;
      case 'electric':
        return AppColors.typeElectric;
      case 'psychic':
        return AppColors.typePsychic;
      case 'ice':
        return AppColors.typeIce;
      case 'dragon':
        return AppColors.typeDragon;
      case 'dark':
        return AppColors.typeDark;
      case 'fairy':
        return AppColors.typeFairy;
      case 'normal':
        return AppColors.typeNormal;
      case 'fighting':
        return AppColors.typeFighting;
      case 'flying':
        return AppColors.typeFlying;
      case 'poison':
        return AppColors.typePoison;
      case 'ground':
        return AppColors.typeGround;
      case 'rock':
        return AppColors.typeRock;
      case 'bug':
        return AppColors.typeBug;
      case 'ghost':
        return AppColors.typeGhost;
      case 'steel':
        return AppColors.typeSteel;
      default:
        return AppColors.typeNormal;
    }
  }
}

