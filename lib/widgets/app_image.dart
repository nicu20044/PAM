
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
    if (name.isEmpty) {
      return _placeholder();
    }

    return Image.network(
      name,
      fit: fit,
      alignment: alignment,
      width: double.infinity,
      height: double.infinity,

      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }

        return const ColoredBox(
          color: AppColors.placeholder,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },

      errorBuilder: (context, error, stackTrace) {
        debugPrint('Image loading error: $name');
        debugPrint('Error: $error');

        return _placeholder();
      },
    );
  }

  Widget _placeholder() {
    if (cutout) {
      return const Center(
        child: Icon(
          Icons.person_outline,
          size: 54,
          color: Colors.black26,
        ),
      );
    }

    return const ColoredBox(
      color: AppColors.placeholder,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: Color(0xFFBDBDC3),
        ),
      ),
    );
  }
}
