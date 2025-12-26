import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class PokemonNetworkImage extends StatelessWidget {
  const PokemonNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  final String imageUrl;
  final BoxFit fit;
  final int? memCacheWidth;
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (kIsWeb) {
      // En web usar Image.network directo (el browser cachea automáticamente)
      return Image.network(
        imageUrl,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading image: $imageUrl');
          debugPrint('Error: $error');
          return Icon(
            Icons.catching_pokemon,
            size: 64,
            color: colors.error,
          );
        },
      );
    }

    // En mobile usar CachedNetworkImage para caché persistente
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.catching_pokemon,
        size: 64,
        color: colors.error,
      ),
    );
  }
}

