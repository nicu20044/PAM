import 'package:flutter_bloc/flutter_bloc.dart';

/// Starea este multimea de id-uri ale produselor favorite.
class FavoritesCubit extends Cubit<Set<String>> {
  FavoritesCubit() : super(const {});

  void seed(Iterable<String> ids) => emit({...state, ...ids});

  void toggle(String id) {
    final s = {...state};
    if (!s.remove(id)) s.add(id);
    emit(s);
  }

  bool isFavorite(String id) => state.contains(id);
}