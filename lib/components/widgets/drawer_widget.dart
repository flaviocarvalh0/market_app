import 'package:flutter/material.dart';
import 'package:market_app/utils/app_routes.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem vindo Usuário'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Produtos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.home,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Pedidos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.orders,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.auto_awesome_motion_rounded),
            title: const Text('Gerenciar Produtos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.products,
              );
            },
          ),
        ],
      ),
    );
  }
}
