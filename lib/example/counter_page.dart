import 'package:flutter/material.dart';
import 'package:market_app/example/exemple_provider.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ExempleProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplo contador'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  provider?.state.dec();
                });
              },
              icon: const Icon(Icons.remove),
            ),
            Text(provider?.state.value.toString() ?? '0'),
            IconButton(
              onPressed: () {
                setState(() {
                  provider?.state.inc();
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
