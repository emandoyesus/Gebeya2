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
    final placeholderColor = isDark ? AppColors.darkCard : AppColors.lightDivider;
    final mutedIconColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    if (imageUrl.isEmpty) {
      return Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        color: placeholderColor,
        child: Icon(Icons.shopping_bag_outlined, color: mutedIconColor),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: Image.network(
        imageUrl,
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return SizedBox.expand(child: child);
          }
          return Container(
            key: const ValueKey('image_placeholder'),
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            color: placeholderColor,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            color: placeholderColor,
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: mutedIconColor,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }
}
