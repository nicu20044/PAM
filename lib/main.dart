import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'state/cart_state.dart';
import 'state/favorites_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartState()),
        ChangeNotifierProvider(create: (_) => FavoritesState()),
      ],
      child: const GemStoreApp(),
    ),
  );
}

class GemStoreApp extends StatelessWidget {
  const GemStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GemStore',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFF1F1F3),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ClipRect(child: child!),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}