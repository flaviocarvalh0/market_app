import 'package:flutter/material.dart';

class CounterState {
  int _value = 0;

  void inc() => _value++;
  void dec() => _value--;

  int get value => _value;

  bool diff(CounterState old) {
    return old._value != _value;
  }
}

class ExempleProvider extends InheritedWidget {
  final CounterState state = CounterState();
  ExempleProvider({super.key, required Widget child}) : super(child: child);

  static ExempleProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ExempleProvider>();
  }

  @override
  bool updateShouldNotify(covariant ExempleProvider oldWidget) {
    throw oldWidget.state.diff(state);
  }
}
