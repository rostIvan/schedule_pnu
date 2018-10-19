import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
import 'package:lessons_schedule_pnu/di/select.dart';
import 'package:lessons_schedule_pnu/page/home/view.dart';
import 'package:lessons_schedule_pnu/page/preloader/logo.dart';
import 'package:lessons_schedule_pnu/page/selection/view.dart';
import 'package:lessons_schedule_pnu/util/support.dart';

class PreloaderPage extends StatefulWidget {
  final SharedPrefWrapper sharedPref = SharedPrefWrapper();

  @override
  State<StatefulWidget> createState() => PreloaderState();
}

class PreloaderState extends State<PreloaderPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), _initialRoute);
  }

  @override
  Widget build(BuildContext context) => Scaffold(body: Preloader());

  void _initialRoute() async {
    var alreadyAuth = await _isUserAuthenticated();
    if (alreadyAuth) {
      var selectedData = await _getData();
      _showHomePage(selectedData);
    } else
      _showSelectPage();
  }

  void _showSelectPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => SelectionPage(searchStore(ScheduleType.GROUP), searchInteractor(type: ScheduleType.GROUP))));
  }

  void _showHomePage(SelectedData selectedData) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage(data: selectedData)));
  }

  Future<bool> _isUserAuthenticated() => widget.sharedPref.isAuthenticated();
  Future<SelectedData> _getData() => widget.sharedPref.selectedData();
}

class Preloader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Container(decoration: BoxDecoration(color: Theme.of(context).accentColor)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(child: _logo()),
              Center(child: _progress())
            ],
          )
        ],
      );

  Logo _logo() => Logo(radius: 90.0, textSize: 32.0);
  CircularProgressIndicator _progress() => CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
}