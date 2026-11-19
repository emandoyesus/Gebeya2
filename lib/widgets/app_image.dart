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
        color: isDark ? AppColors.darkSurface : AppColors.lightDivider,
        child: const Icon(Icons.shopping_bag_outlined, color: AppColors.lightTextMuted),
      );
    }

    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: isDark ? AppColors.darkSurface : AppColors.lightDivider,
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: isDark ? AppColors.darkSurface : AppColors.lightDivider,
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
