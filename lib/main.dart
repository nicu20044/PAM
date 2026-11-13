import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/cart_cubit.dart';
import 'cubits/catalog_cubit.dart';
import 'cubits/favorites_cubit.dart';
import 'data/store_repository.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CatalogCubit(StoreRepository())..load()),
        BlocProvider(create: (_) => FavoritesCubit()),
        BlocProvider(create: (_) => CartCubit()),
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
      builder: (context, child) => BlocListener<CatalogCubit, CatalogState>(
        // cand JSON-ul s-a incarcat, marcam favoritele initiale ("isFavorite": true)
        listenWhen: (prev, curr) => prev.data == null && curr.data != null,
        listener: (context, state) {
          context.read<FavoritesCubit>().seed(
            state.data!.allProducts
                .where((p) => p.initiallyFavorite)
                .map((p) => p.id),
          );
        },
        child: ColoredBox(
          color: const Color(0xFFF1F1F3),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: ClipRect(child: child!),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}