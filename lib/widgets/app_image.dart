import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppImage extends StatelessWidget {
  final String name;
  final BoxFit fit;
  final Alignment alignment;
  final bool cutout;

  const AppImage(
    this.name, {
    super.key,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.cutout = false,
  });

  @override
  Widget build(BuildContext context) {
    if (name.isEmpty) return _placeholder();
    return Image.asset(
      'assets/images/$name',
      fit: fit,
      alignment: alignment,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    if (cutout) {
      return const Center(
        child: Icon(Icons.person_outline, size: 54, color: Colors.black26),
      );
    }
    return const ColoredBox(
      color: AppColors.placeholder,
      child: Center(
        child: Icon(Icons.image_outlined, color: Color(0xFFBDBDC3)),
      ),
    );
  }
}
