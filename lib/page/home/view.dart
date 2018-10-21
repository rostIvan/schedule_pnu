import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
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

  Widget _page(int index) => PageFactory.create(index);

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
  static List<Widget> pages;

  static Widget create(index) {
    if(pages == null)
      pages = [FirstPage(), SecondPage(), ThirdPage()];
    return pages[index];
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Column(
    children: <Widget>[
      ScheduleCard(label: 'Сьогодні', dayShort: 'Пн.', date: '12.10', icon: Icons.calendar_today),
      ScheduleCard(label: 'Завтра', dayShort: 'Вт.', date: '13.10', icon: Icons.today),
    ],
  ));
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Column(
    children: <Widget>[
      ScheduleCard(label: 'Тиждень', dayShort: 'Пн. - Сб.', date: '12.10 - 18.10', icon: Icons.next_week),
      ScheduleCard(label: '2 тижні', dayShort: 'Пн. - Сб.', date: '12.10 - 25.10', icon: Icons.shop_two),
    ],
  ));
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Column(
    children: <Widget>[
      ScheduleCard(label: 'Вибрати дату', dayShort: '', date: 'дд.мм.рр', icon: Icons.calendar_view_day),
      ScheduleCard(label: 'Вибрати період', dayShort: '', date: 'дд.мм.рр - дд.мм.рр', icon: Icons.date_range),
    ],
  ));
}


class ScheduleCard extends StatelessWidget {
  final String date;
  final String dayShort;
  final String label;
  final IconData icon;
  const ScheduleCard({Key key, this.date, this.dayShort, this.label, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var imageRadius = height * 0.1;
    var card = Container(
      padding: _innerPadding(width, height),
      decoration: _borderRadiusDecoration(context),
      child: _content(context, height, imageRadius),
    );
    var expanded = Expanded(child: Padding(padding: _outerPadding(width, height), child: Opacity(opacity: 0.9, child: card)));
    return expanded;
  }

  Widget _content(BuildContext context, double height, double imageRadius) => LayoutBuilder(
        builder: (context, box) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _header(),
              box.biggest.height > 80.0 ? _centerCircleImage(context, imageRadius) : SizedBox(),
              _bottomLabel()
            ]
        )
    );

  Widget _bottomLabel() => Flexible(child: _textBottom(label));

  Widget _centerCircleImage(BuildContext context, double r) => Flexible(
      flex: 2,
      child: CircleAvatar(radius: r,
          backgroundColor: Colors.white,
          child: Icon(icon, size: r * 0.75, color: Theme.of(context).primaryColor)
      )
  );

  Widget _header() => Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[ _textHeader(dayShort), _textHeader(date) ],
      )
  );

  BoxDecoration _borderRadiusDecoration(BuildContext context) => BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(14.0))
  );

  EdgeInsets _innerPadding(double width, double height) => EdgeInsets.symmetric(horizontal: width * 0.025, vertical: height * 0.0105);
  EdgeInsets _outerPadding(double width, double height) => EdgeInsets.symmetric(horizontal: width * 0.1, vertical: height * 0.05);

  Text _textHeader(text) => Text(text, style: TextStyle(color: Colors.white, fontSize: 18.0));
  Text _textBottom(text) => Text(text, style: TextStyle(color: Colors.white, fontSize: 24.0));
}
