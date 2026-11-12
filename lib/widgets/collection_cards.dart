import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_image.dart';

class CollectionCard extends StatelessWidget {
  final String tag;
  final String title;
  final String image;
  final Color circleColor;
  final double height;
  final bool boldTitle;
  final bool fullBleed;
  final VoidCallback? onTap;

  const CollectionCard({
    super.key,
    required this.tag,
    required this.title,
    required this.image,
    required this.circleColor,
    this.height = 120,
    this.boldTitle = false,
    this.fullBleed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final circle = height > 140 ? 135.0 : 108.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(horizontal: fullBleed ? 0 : 20),
        decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(fullBleed ? 0 : 12),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 22,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: circle + 10,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: circle,
                      height: circle,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: circleColor),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: (height - circle) / 2 - 6,
                      top: (height - circle) / 2 - 12,
                      child: AppImage(image,
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomCenter,
                          cutout: true),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 22,
              top: 0,
              bottom: 0,
              right: circle + 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 1, height: 10, color: AppColors.grey),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(tag,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 9.5, color: AppColors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: boldTitle ? 19 : 18,
                      height: 1.3,
                      fontWeight: boldTitle ? FontWeight.w700 : FontWeight.w500,
                      color: boldTitle ? AppColors.ink : const Color(0xFF6B6B78),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CollectionTile extends StatelessWidget {
  final String label;
  final String title;
  final String image;
  final bool imageLeft;
  final VoidCallback? onTap;

  const CollectionTile({
    super.key,
    required this.label,
    required this.title,
    required this.image,
    this.imageLeft = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 160,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: imageLeft ? 0 : null,
                right: imageLeft ? null : 0,
                width: 80,
                child: AppImage(image, alignment: Alignment.topCenter),
              ),
              Positioned(
                top: 32,
                left: imageLeft ? 88 : 14,
                right: imageLeft ? 8 : 88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.grey)),
                    const SizedBox(height: 6),
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15,
                            height: 1.25,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}