import 'package:flutter/material.dart';
import 'package:market_app/components/order/order_item.dart';
import 'package:provider/provider.dart';

import '../../components/widgets/drawer_widget.dart';
import '../../providers/order_provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false).loadOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return const Center(
              child: Text('Ocorreu um erro!'),
            );
          } else {
            return Consumer<OrderProvider>(
              builder: (context, orders, child) => ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (context, index) {
                  return OrderItem(
                    order: orders.items[index],
                  );
                },
              ),
            );
          }
        },
      ),
      drawer: const DrawerWidget(),
    );
  }
}
