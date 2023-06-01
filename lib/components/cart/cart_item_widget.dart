import 'package:flutter/material.dart';
import 'package:market_app/models/cart_item.dart';
import 'package:market_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  const CartItemWidget(
    this.cartItem, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartProvider provider = Provider.of(
      context,
      listen: false,
    );
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: (_) {
        provider.removeItem(cartItem.productId);
      },
      confirmDismiss: (_) {
        return showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Tem certeza?'),
                  content: const Text(
                    'Quer remover o item do carrinho?',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('Não'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Sim'),
                    ),
                  ],
                ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 10,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: FittedBox(
                child: Text(
                  'R\$${cartItem.price.toString()}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          title: Text(
            cartItem.name,
            style: const TextStyle(color: Colors.black),
          ),
          subtitle: Text(
              'R\$ ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
          trailing: Container(
            width: 140,
            child: Row(
              children: [
                IconButton(
                  onPressed: cartItem.quantity <= 1
                      ? null
                      : () => provider.decreasesQuantity(
                            cartItem.productId,
                            cartItem.quantity,
                          ),
                  icon: const Icon(Icons.remove),
                ),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        cartItem.quantity.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    provider.addQuantity(cartItem.productId);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
