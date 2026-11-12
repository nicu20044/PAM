import 'package:flutter/foundation.dart';

class FavoritesState extends ChangeNotifier {
  final Set<String> _ids = {};
  Set<String> get ids => _ids;
  bool isFavorite(String id) => _ids.contains(id);

  void toggle(String id) {
    if (!_ids.remove(id)) _ids.add(id);
    notifyListeners();
  }
}