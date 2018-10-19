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
    setState(() {
      radius += 30;
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      AnimatedSize(
          child: _logo(),
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
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

  Widget _avatar() => PnuAvatar(radius: radius);
  Widget _logoText() => Padding(child: Text('Розклад ПНУ', style: TextStyle(fontSize: textSize, color: Colors.white)), padding: EdgeInsets.all(12.0));
}

class PnuAvatar extends StatelessWidget {
  final double radius;
  const PnuAvatar({this.radius = 24.0, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => CircleAvatar(child: Image.asset('assets/pnu_logo.png'), radius: radius, backgroundColor: Colors.transparent);
}