import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
import 'package:lessons_schedule_pnu/page/home/cards.dart';
import 'package:lessons_schedule_pnu/page/home/drawer.dart';
import 'package:lessons_schedule_pnu/page/home/indicator.dart';


class HomePage extends StatelessWidget {
  final SelectedData data;
  final String startMessage;
  HomePage({Key key, this.data, this.startMessage}): super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: _createAppBar(),
    drawer: HomeDrawer(data),
    body: HomeBody(data, startMessage: startMessage),
  );

  AppBar _createAppBar() => AppBar(title: Text('Розклад ПНУ'));
}

class HomeBody extends StatefulWidget {
  final String startMessage;
  final SelectedData data;
  const HomeBody(this.data, {Key key, this.startMessage}) : super(key: key);
  @override
  State<StatefulWidget> createState() => BodyState();
}

class BodyState extends State<HomeBody> {
  final pageIndexNotifier = ValueNotifier<int>(0);
  final int length = 3;

  @override
  void initState() {
    super.initState();
    _showSelectSnack();
  }

  @override
  Widget build(BuildContext context) => _createBody();

  Widget _createBody() => Stack(
      children: <Widget>[
        _pageView(),
        _pageIndicator()
      ]
  );

  Widget _pageView() => PageView.builder(
      scrollDirection: Axis.vertical,
      onPageChanged: (index) => pageIndexNotifier.value = index,
      itemCount: length,
      itemBuilder: (context, index) => _page(index)
  );

  Widget _page(int index) => PageFactory.create(index, widget.data);

  Widget _pageIndicator() => PageIndicator(
    valueNotifier: pageIndexNotifier,
    length: length,
    normalIndicator: Circle(color: Colors.transparent, size: 12.0),
    selectedIndicator: Circle(color: Theme.of(context).primaryColor, size: 12.0)
  );

  void _showSelectSnack() {
    var message = widget.startMessage;
    if(message != null)
      Future.delayed(Duration.zero, () {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(message), duration: Duration(seconds: 3)));
      });
  }
}

class PageFactory {
  static Widget create(index, data) {
    final List<Widget> pages = [FirstPage(data), SecondPage(data), ThirdPage(data)];
    return pages[index];
  }
}