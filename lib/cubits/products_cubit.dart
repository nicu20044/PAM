import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';

enum PriceFilter { all, under35, mid, over50 }

extension PriceFilterX on PriceFilter {
  String get label => switch (this) {
    PriceFilter.all => 'All',
    PriceFilter.under35 => 'Under \$35',
    PriceFilter.mid => '\$35 - \$50',
    PriceFilter.over50 => 'Over \$50',
  };

  bool matches(double p) => switch (this) {
    PriceFilter.all => true,
    PriceFilter.under35 => p < 35,
    PriceFilter.mid => p >= 35 && p <= 50,
    PriceFilter.over50 => p > 50,
  };
}

enum SortOption { relevance, priceAsc, priceDesc, nameAsc }

extension SortOptionX on SortOption {
  String get label => switch (this) {
    SortOption.relevance => 'Default',
    SortOption.priceAsc => 'Price: low to high',
    SortOption.priceDesc => 'Price: high to low',
    SortOption.nameAsc => 'Name: A-Z',
  };
}

class ProductsState {
  final List<Product> base;
  final String query;
  final PriceFilter price;
  final SortOption sort;

  const ProductsState({
    required this.base,
    this.query = '',
    this.price = PriceFilter.all,
    this.sort = SortOption.relevance,
  });

  ProductsState copyWith({
    String? query,
    PriceFilter? price,
    SortOption? sort,
  }) =>
      ProductsState(
        base: base,
        query: query ?? this.query,
        price: price ?? this.price,
        sort: sort ?? this.sort,
      );

  bool get hasFilters =>
      query.isNotEmpty ||
          price != PriceFilter.all ||
          sort != SortOption.relevance;

  /// Lista rezultata dupa cautare + filtrare + sortare.
  List<Product> get visible {
    final q = query.trim().toLowerCase();
    final list = base
        .where((p) =>
    (q.isEmpty || p.name.toLowerCase().contains(q)) &&
        price.matches(p.price))
        .toList();
    switch (sort) {
      case SortOption.priceAsc:
        list.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceDesc:
        list.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.nameAsc:
        list.sort((a, b) => a.name.compareTo(b.name));
      case SortOption.relevance:
        break;
    }
    return list;
  }
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(List<Product> base) : super(ProductsState(base: base));

  Timer? _debounce;

  /// Cautarea asteapta 300ms dupa ultima tasta (debounce, asincron).
  void search(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      emit(state.copyWith(query: q));
    });
  }

  void setPrice(PriceFilter f) => emit(state.copyWith(price: f));
  void setSort(SortOption s) => emit(state.copyWith(sort: s));

  void reset() {
    _debounce?.cancel();
    emit(ProductsState(base: state.base));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}