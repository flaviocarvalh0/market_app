// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:market_app/excepctions/http_exception.dart';
import 'package:market_app/models/product.dart';
import 'package:market_app/utils/constantes.dart';

class ProductProvider with ChangeNotifier {
  final String _token;
  final String userId;

  List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get favoritieItems =>
      _items.where((element) => element.isFavorite).toList();

  ProductProvider(this._token, this._items, this.userId);
  int get productCount => _items.length;

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(
      Uri.parse('${Constantes.PRODUCT_BASE_URL}.json?auth=$_token'),
    );
    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse('${Constantes.FAVORITES_USER_URL}/$userId.json?auth=$_token'),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;

      String priceConvert = productData['price'].toString();
      double priceConverted = double.tryParse(priceConvert) ?? 0.0;
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: priceConverted,
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addItem(Product product) async {
    final response = await http.post(
      Uri.parse('${Constantes.PRODUCT_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        },
      ),
    );
    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, dynamic> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateItem(product);
    } else {
      return addItem(product);
    }
  }

  Future<void> updateItem(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constantes.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          },
        ),
      );

      _items[index] = product;
    }
    notifyListeners();

    return Future.value();
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constantes.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();

        throw HttpException(
          msg: 'Não foi possível excluir o item',
          statusCode: response.statusCode,
        );
      }
    }
  }

  void removeItem(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  Future<void> toggleFavorite(Product product) async {
    product.toggleFavorite();
    final response = await http.put(
      Uri.parse(
          '${Constantes.FAVORITES_USER_URL}/$userId/${product.id}.json?auth=$_token'),
      body: jsonEncode(
        product.isFavorite,
      ),
    );

    if (response.statusCode >= 400) {
      product.toggleFavorite();
      throw HttpException(
          msg: 'Error ao marcar/desmarcar como favorito este produto',
          statusCode: response.statusCode);
    }
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
