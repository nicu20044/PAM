import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartState extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  int get count => _items.fold(0, (s, i) => s + i.qty);
  double get total => _items.fold(0.0, (s, i) => s + i.total);

  void add(Product p, int colorIndex, String size) {
    final i = _items.indexWhere((e) =>
    e.product.id == p.id && e.colorIndex == colorIndex && e.size == size);
    if (i >= 0) {
      _items[i].qty++;
    } else {
      _items.add(CartItem(product: p, colorIndex: colorIndex, size: size));
    }
    notifyListeners();
  }

  void increment(CartItem item) {
    item.qty++;
    notifyListeners();
  }

  void decrement(CartItem item) {
    if (item.qty > 1) {
      item.qty--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}