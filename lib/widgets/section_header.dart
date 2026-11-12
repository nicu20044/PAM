import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onShowAll;
  const SectionHeader({super.key, required this.title, this.onShowAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
          GestureDetector(
            onTap: onShowAll,
            child: const Text('Show all',
                style: TextStyle(fontSize: 12, color: AppColors.grey)),
          ),
        ],
      ),
    );
  }
}