import 'package:flutter/material.dart';
import 'package:market_app/data/dummy_data.dart';
import 'package:market_app/models/product.dart';

class ProductListProvider with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get itemm => [..._items];

  void addItem(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.remove(product);
    notifyListeners();
  }
}
