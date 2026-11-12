import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Stars extends StatelessWidget {
  final double rating;
  final double size;
  const Stars({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
            (i) => Icon(
          i < rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: AppColors.green,
        ),
      ),
    );
  }
}