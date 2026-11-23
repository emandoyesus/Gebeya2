import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (imageUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: isDark ? const Color(0xFF141418) : AppColors.lightDivider,
        child: const Icon(Icons.shopping_bag_outlined, color: AppColors.lightTextMuted),
      );
    }

    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: frame != null
              ? child
              : Container(
                  key: const ValueKey('image_placeholder'),
                  width: width,
                  height: height,
                  color: isDark ? const Color(0xFF141418) : AppColors.lightDivider,
                ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: isDark ? const Color(0xFF141418) : AppColors.lightDivider,
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.lightTextMuted,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
