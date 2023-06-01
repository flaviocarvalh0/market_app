import 'package:flutter/material.dart';
import 'package:market_app/components/cart/cart_item_widget.dart';
import 'package:market_app/providers/cart_provider.dart';
import 'package:market_app/providers/order_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final CartProvider cart = Provider.of(context);
    final OrderProvider order = Provider.of(context, listen: false);
    final _items = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            elevation: 7,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Spacer(),
                  ButtonBuy(order: order, cart: cart),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: 500,
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) => CartItemWidget(
                _items[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonBuy extends StatefulWidget {
  const ButtonBuy({
    super.key,
    required this.order,
    required this.cart,
  });

  final OrderProvider order;
  final CartProvider cart;

  @override
  State<ButtonBuy> createState() => _ButtonBuyState();
}

class _ButtonBuyState extends State<ButtonBuy> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.itemsCount == 0
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    await widget.order.addOrder(widget.cart);
                    widget.cart.clear();
                    setState(() => _isLoading = false);
                  },
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: const Text('COMPRAR'),
          );
  }
}
