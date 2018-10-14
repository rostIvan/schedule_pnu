import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: _createAppBar(),
    body: null,
  );

  AppBar _createAppBar() => AppBar(title: Text('Розклад ПНУ'));
}