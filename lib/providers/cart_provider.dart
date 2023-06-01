import 'dart:math';

import 'package:flutter/material.dart';
import 'package:market_app/models/cart_item.dart';
import 'package:market_app/models/product.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  int get itemsCount => _items.length;

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (value) => CartItem(
          id: value.id,
          productId: value.productId,
          name: value.name,
          quantity: value.quantity + 1,
          price: value.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.name,
          quantity: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  void addQuantity(String productId) {
    _items.update(
      productId,
      (value) => CartItem(
          id: value.id,
          productId: value.productId,
          name: value.name,
          quantity: value.quantity + 1,
          price: value.price),
    );
    notifyListeners();
  }

  void decreasesQuantity(String productId, int quantity) {
    if (quantity <= 1) {
      return;
    } else {
      _items.update(
        productId,
        (value) => CartItem(
            id: value.id,
            productId: value.productId,
            name: value.name,
            quantity: value.quantity - 1,
            price: value.price),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]?.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (value) => CartItem(
            id: value.id,
            productId: value.productId,
            name: value.name,
            quantity: value.quantity - 1,
            price: value.price),
      );
    }
    notifyListeners();
  }

  double get totalAmount {
    double total = 0;
    _items.forEach(
      (key, cartItem) {
        total += cartItem.price * cartItem.quantity;
      },
    );
    return total;
  }
}
