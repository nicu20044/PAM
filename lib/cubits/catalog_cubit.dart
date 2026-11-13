import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/store_repository.dart';
import '../models/product.dart';

enum CatalogStatus { loading, success, error }

class CatalogState {
  final CatalogStatus status;
  final StoreData? data;
  final String category;
  final String? error;

  const CatalogState({
    this.status = CatalogStatus.loading,
    this.data,
    this.category = 'women',
    this.error,
  });

  CatalogState copyWith({String? category}) => CatalogState(
    status: status,
    data: data,
    category: category ?? this.category,
    error: error,
  );

  /// Produsele "Feature" din categoria aleasa.
  List<Product> get featuredForCategory => data == null
      ? const []
      : data!.featured.where((p) => p.category == category).toList();
}

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this._repo) : super(const CatalogState());

  final StoreRepository _repo;

  Future<void> load() async {
    emit(CatalogState(category: state.category));
    try {
      final data = await _repo.load();
      final initial = data.categories
          .firstWhere((c) => c.selected, orElse: () => data.categories.first)
          .id;
      emit(CatalogState(
          status: CatalogStatus.success, data: data, category: initial));
    } catch (e) {
      emit(CatalogState(
          status: CatalogStatus.error, category: state.category, error: '$e'));
    }
  }

  void selectCategory(String id) {
    if (state.status == CatalogStatus.success) {
      emit(state.copyWith(category: id));
    }
  }
}