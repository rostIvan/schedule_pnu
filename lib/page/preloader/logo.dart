import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  final double radius;
  final double textSize;

  Logo({Key key, this.radius, this.textSize}) : super(key: key);
  @override
  _LogoState createState() => _LogoState(radius, textSize);
}

class _LogoState extends State<Logo> with TickerProviderStateMixin {
  double radius;
  double textSize;
  _LogoState(this.radius, this.textSize);

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 800), () {
      setState(() {
        radius += 30;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      AnimatedSize(
          child: _logo(),
          duration: Duration(seconds: 15),
          curve: Curves.bounceOut,
          vsync: this
      )
    ],
  );

  Widget _logo() => Column(
    children: <Widget>[
      _avatar(),
      _logoText()
    ],
  );

  Widget _avatar() => CircleAvatar(child: Image.asset('assets/pnu_logo.png'), radius: radius, backgroundColor: Colors.transparent);
  Widget _logoText() => Padding(child: Text('Розклад ПНУ', style: TextStyle(fontSize: textSize, color: Colors.white)), padding: EdgeInsets.all(12.0));
}