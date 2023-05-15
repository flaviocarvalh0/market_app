import 'package:flutter/material.dart';
import 'package:market_app/data/dummy_data.dart';
import 'package:market_app/models/product.dart';

class ProductListProvider with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoritieItems =>
      _items.where((element) => element.isFavorite).toList();

  void addItem(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.remove(product);
    notifyListeners();
  }
}

// bool _showFavoritiesOnly = false;

//   List<Product> get items {
//     if (_showFavoritiesOnly) {
//       return _items.where((prod) => prod.isFavorite).toList();
//     }
//     return [..._items];
//   }

//   void showFavoritiesOnly() {
//     _showFavoritiesOnly = true;
//     notifyListeners();
//   }

//   void showAll() {
//     _showFavoritiesOnly = false;
//     notifyListeners();
//   }
