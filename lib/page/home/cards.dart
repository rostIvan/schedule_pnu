import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
import 'package:lessons_schedule_pnu/page/schedule/view.dart';
import 'package:lessons_schedule_pnu/util/date.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;


class FirstPage extends CardsDatePage {
  final HeroText todayHeroText = HeroText('todayHeroText', 'сьогодні');
  final HeroText tomorrowHeroText = HeroText('tomorrowHeroText', 'завтра');

  FirstPage(SelectedData data) : super(data);

  @override
  Widget build(BuildContext context) => Center(child: Column(
    children: <Widget>[
      ScheduleCard(
        label: 'Сьогодні',
        onClick: () => navigate(context, SchedulePage(data, dateTime: _today, heroText: todayHeroText)),
        dayShort: formatWeekDay(_today),
        date: formatSingleDate(_today),
        icon: Icons.calendar_today,
        tag: todayHeroText.tag,
      ),
      ScheduleCard(
        label: 'Завтра',
        onClick: () => navigate(context, SchedulePage(data, dateTime: _tomorrow, heroText: tomorrowHeroText)),
        dayShort: formatWeekDay(_tomorrow),
        date: formatSingleDate(_tomorrow),
        icon: Icons.today,
        tag: tomorrowHeroText.tag,
      ),
    ],
  ));
}

class SecondPage extends CardsDatePage {
  final HeroText weekHeroText = HeroText('weekHeroText', 'тиждень');
  final HeroText twoWeeksHeroText = HeroText('twoWeeksHeroText', '2 тижні');

  SecondPage(SelectedData data) : super(data);

  @override
  Widget build(BuildContext context) => Center(child: Column(
    children: <Widget>[
      ScheduleCard(
        label: 'Тиждень',
        onClick: () => navigate(context, SchedulePage(data, period: SchedulePeriod(_today, _week), heroText: weekHeroText)),
        dayShort: formatWeekDay(_today),
        date: formatRangeDates(_today, _week),
        icon: Icons.next_week,
        tag: weekHeroText.tag,
      ),
      ScheduleCard(
        label: '2 тижні',
        onClick: () => navigate(context, SchedulePage(data, period: SchedulePeriod(_today, _twoWeeks),  heroText: twoWeeksHeroText)),
        dayShort: formatWeekDay(_today),
        date: formatRangeDates(_today, _twoWeeks),
        icon: Icons.shop_two,
        tag: twoWeeksHeroText.tag,
      ),
    ],
  ));
}

class ThirdPage extends CardsDatePage {
  final HeroText dateSelectHeroText = HeroText('dateSelectHeroText', 'дату');
  final HeroText dateRangeHeroText = HeroText('dateRangeHeroText', 'період');

  ThirdPage(SelectedData data) : super(data);

  @override
  Widget build(BuildContext context) => Center(child: Column(
    children: <Widget>[
      ScheduleCard(
        label: 'Вибрати дату',
        onClick: () => _pickDate(context),
        dayShort: '',
        date: 'дд.мм.рр',
        icon: Icons.calendar_view_day,
        tag: dateSelectHeroText.tag,
      ),
      ScheduleCard(
        label: 'Вибрати період',
        onClick: () => _pickDateRange(context),
        dayShort: '',
        date: 'дд.мм.рр - дд.мм.рр',
        icon: Icons.date_range,
        tag: dateRangeHeroText.tag,
      ),
    ],
  ));

  void _pickDate(context) {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(_today.year, DateTime.september),
        lastDate: DateTime(_today.year + 1, DateTime.september - 1)
    ).then((picked) {
      if(picked != null)
        navigate(context, SchedulePage(data, dateTime: picked, heroText: dateSelectHeroText));
    });
  }

  void _pickDateRange(context) {
    DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: _today,
        initialLastDate: _today,
        firstDate: DateTime(_today.year, DateTime.september),
        lastDate: DateTime(_today.year + 1, DateTime.september - 1)
    ).then((picked) {
      if(picked != null && picked.where((e) => e != null).toList().length > 1)
        navigate(context, SchedulePage(data, period: SchedulePeriod(picked[0], picked[1]), heroText: dateRangeHeroText));
    });
  }
}

abstract class CardsDatePage extends StatelessWidget {
  final SelectedData data;
  final _today = DateTime.now();
  final _tomorrow = fromNow(days: 1);
  final _week = fromNow(days: 7);
  final _twoWeeks = fromNow(days: 14);

  CardsDatePage(this.data, {Key key}) : super(key: key);

  @protected
  static DateTime fromNow({int days}) => DateTime.now().add(Duration(days: days));

  @protected
  void navigate(context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class ScheduleCard extends StatefulWidget {
  final VoidCallback onClick;
  final String date;
  final String dayShort;
  final String label;
  final IconData icon;
  final String tag;
  const ScheduleCard({Key key, this.date, this.dayShort, this.label, this.icon, this.onClick, this.tag}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScheduleCardState();
}

class ScheduleCardState extends State<ScheduleCard> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<int> _zoomOut;
  Animation<double> _fade;

  @override
  void initState() {
    _animationController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _fade = Tween(begin: 1.0, end: 0.0).animate(_animationController)..addListener(() {
      setState(() {});
    });
    _zoomOut = IntTween(begin: 50, end: 600).animate(_animationController)..addListener(() {
      setState(() {});
    });
    _animationController.addListener(() {
      if (_animationController.isCompleted)
        widget.onClick();
    });
    super.initState();
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<Null> animate() async {
    try {
      await _animationController.forward();
      _animationController.reverse();
    }
    on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var card = GestureDetector(child: Container(
      padding: _innerPadding(width, height),
      decoration: _borderRadiusDecoration(context),
      child: _content(context, height),
    ), onTap: animate);
    var expanded = Expanded(child: Padding(padding: _outerPadding(width, height), child: Opacity(opacity: 0.9, child: card)));
    return expanded;
  }

  Widget _content(BuildContext context, double height) {
    var imageRadius = height * 0.1;
    var layoutBuilder = LayoutBuilder(
        builder: (context, box) => Opacity(opacity: _fade.value, child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _header(),
              box.biggest.height > 80.0 ? _centerCircleImage(context, imageRadius) : SizedBox(),
              _bottomLabel()
            ]
        ))
    );
    return layoutBuilder;
  }

  Widget _bottomLabel() => Flexible(child: _textBottom(widget.label));

  Widget _centerCircleImage(BuildContext context, double r) => Flexible(
      flex: 2,
      child: CircleAvatar(radius: r,
          backgroundColor: Colors.white,
          child: Icon(widget.icon, size: r * 0.75, color: Theme.of(context).primaryColor)
      )
  );

  Widget _header() => Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[ _textHeader(widget.dayShort), _textHeader(widget.date) ],
      )
  );

  BoxDecoration _borderRadiusDecoration(BuildContext context) => BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: _zoomOut.value < 500 ? BorderRadius.all(Radius.circular(14.0)) : BorderRadius.zero
  );

  EdgeInsets _innerPadding(double width, double height) => EdgeInsets.symmetric(horizontal: width * 0.025, vertical: height * 0.0105);
  EdgeInsets _outerPadding(double width, double height) {
//    var horizontal = width * 0.1;
//    var vertical = height * 0.05;
    var horizontal = width * 0.1 * (1 - ((_zoomOut.value - 50) / 550));
    var vertical = height * 0.05 * (1 - ((_zoomOut.value - 50) / 550));
    var edgeInsets = EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
    return edgeInsets;
  }

  Text _textHeader(text) => Text(text, style: TextStyle(color: Colors.white, fontSize: 18.0));
  Widget _textBottom(text) => Hero(
      tag: widget.tag,
      child: Material(
        color: Colors.transparent, child: Text(widget.label),
        textStyle: Theme.of(context).textTheme.title.copyWith(color: Colors.white, fontSize: 24.0))
  );
}

class HeroText {
  final String tag;
  final String text;

  HeroText(this.tag, this.text);
}