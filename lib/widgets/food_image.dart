import 'package:flutter/material.dart';

class FoodImage extends StatelessWidget {
  final String? imageUrl;
  final String dishName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double iconSize;

  const FoodImage({
    super.key,
    required this.imageUrl,
    required this.dishName,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.iconSize = 48,
  });

  String _buildFallbackUrl() {
    final normalized = dishName.trim().toLowerCase().replaceAll(
      RegExp(r'\s+'),
      '-',
    );
    final seed = Uri.encodeComponent(normalized.isEmpty ? 'food' : normalized);
    return 'https://picsum.photos/seed/$seed/800/600';
  }

  @override
  Widget build(BuildContext context) {
    final fallbackUrl = _buildFallbackUrl();
    final primaryUrl = (imageUrl != null && imageUrl!.trim().isNotEmpty)
        ? imageUrl!.trim()
        : fallbackUrl;

    Widget unsupportedIcon = Icon(Icons.image_not_supported, size: iconSize);

    return Image.network(
      primaryUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        if (primaryUrl != fallbackUrl) {
          return Image.network(
            fallbackUrl,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => unsupportedIcon,
          );
        }
        return unsupportedIcon;
      },
    );
  }
}
