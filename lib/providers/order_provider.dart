import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:market_app/models/cart_item.dart';
import 'package:market_app/models/order.dart';
import 'package:market_app/providers/cart_provider.dart';
import 'package:market_app/utils/constantes.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> loadOrders() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constantes.ORDER_BASE_URL}.json'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      String totalConvert = orderData['total'].toString();
      double totalConverted = double.tryParse(totalConvert) ?? 0.0;
      _items.add(
        Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          total: totalConverted,
          products: (orderData['products'] as List<dynamic>).map((item) {
            String priceConvert = item['price'].toString();
            double priceConverted = double.tryParse(priceConvert) ?? 0.0;
            return CartItem(
              id: item['id'],
              productId: item['productId'],
              name: item['name'],
              quantity: item['quantity'],
              price: priceConverted,
            );
          }).toList(),
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addOrder(CartProvider cart) async {
    DateTime date = DateTime.now();

    final response = await http.post(
      Uri.parse('${Constantes.ORDER_BASE_URL}.json'),
      body: json.encode(
        {
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.items.values
              .map(
                (cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'name': cartItem.name,
                  'price': cartItem.price,
                  'quantity': cartItem.quantity,
                },
              )
              .toList(),
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: date,
      ),
    );
    notifyListeners();
  }
}
