import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';


class HomePage extends StatelessWidget {
  final SelectedData data;
  final String startMessage;
  HomePage({Key key, this.data, this.startMessage}): super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: _createAppBar(),
    body: HomePageBody(data, startMessage: startMessage),
  );

  AppBar _createAppBar() => AppBar(title: Text('Розклад ПНУ'));
}

class HomePageBody extends StatefulWidget {
  final String startMessage;
  final SelectedData data;
  const HomePageBody(this.data, {Key key, this.startMessage}) : super(key: key);
  @override
  State<StatefulWidget> createState() => BodyState();
}

class BodyState extends State<HomePageBody> {
  @override
  void initState() {
    _showSelectSnack();
    super.initState();
  }
  @override
  Widget build(BuildContext context) => _createBody();
  Widget _createBody() => Center(child: Text('Home user: ${widget.data.scheduleType} => ${widget.data.selected}'));

  void _showSelectSnack() {
    var message = widget.startMessage;
    if(message != null)
      Future.delayed(Duration(milliseconds: 500), () {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(message), duration: Duration(seconds: 3)));
      });
  }
}