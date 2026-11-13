import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super(const []);

  int get count => state.fold(0, (s, i) => s + i.qty);
  double get total => state.fold(0.0, (s, i) => s + i.total);

  void add(Product p, int colorIndex, String size) {
    final list = [...state];
    final key = '${p.id}|$colorIndex|$size';
    final i = list.indexWhere((e) => e.key == key);
    if (i >= 0) {
      list[i] = list[i].copyWith(qty: list[i].qty + 1);
    } else {
      list.add(CartItem(product: p, colorIndex: colorIndex, size: size));
    }
    emit(list);
  }

  void increment(CartItem item) => _setQty(item, item.qty + 1);

  void decrement(CartItem item) {
    if (item.qty > 1) {
      _setQty(item, item.qty - 1);
    } else {
      remove(item);
    }
  }

  void remove(CartItem item) =>
      emit(state.where((e) => e.key != item.key).toList());

  void clear() => emit(const []);

  void _setQty(CartItem item, int qty) => emit([
    for (final e in state)
      if (e.key == item.key) e.copyWith(qty: qty) else e
  ]);
}