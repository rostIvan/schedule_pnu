import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
import 'package:lessons_schedule_pnu/page/home/cards.dart';
import 'package:lessons_schedule_pnu/util/date.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class SchedulePage extends StatelessWidget  {
  final SelectedData data;
  final HeroText heroText;
  final DateTime dateTime;
  final SchedulePeriod period;
  const SchedulePage(this.data, {Key key, this.dateTime, this.period, this.heroText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dateTime != null) {
      return SingleDateSchedule(data, dateTime, heroText);
    }
    else if(period != null) {
      return RangeDateSchedule(data, period, heroText);
    }
    return null;
  }
}

class SingleDateSchedule extends StatelessWidget {
  final SelectedData data;
  final DateTime dateTime;
  final HeroText heroText;
  const SingleDateSchedule(this.data, this.dateTime, this.heroText, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    body: ScrollableApp(
        heroText,
        [dateTime],
        body: ScheduleTimeline(data)
    ),
  );
}

class RangeDateSchedule extends StatelessWidget {
  final SelectedData data;
  final SchedulePeriod period;
  final HeroText heroText;
  RangeDateSchedule (this.data, this.period, this.heroText, {Key key});

  @override
  Widget build(BuildContext context) {
    final tabs = _tabs();
    final pages = _pages(tabs);
    return DefaultTabController(length: tabs.length, child: Scaffold(
            body: ScrollableApp(
                heroText,
                _dates(),
                tabs: tabs,
                body: TabBarView(children: pages)
            ),
      ),
    );
  }

  List<Widget> _pages(List<Widget> tabs) => List.generate(tabs.length, (i) => ScheduleTimeline(data));

  List<Widget> _tabs() => _dates()
      .map((date) => Tab(child: Text(formatSingleDate(date))))
      .toList();

  List<DateTime> _dates() {
    final utcPeriod = period.toUtc();
    final dates = dateRange(utcPeriod.from, utcPeriod.to);
    return dates;
  }
}

class ScrollableApp extends StatefulWidget {
  final Widget body;
  final HeroText heroText;
  final List<Widget> tabs;
  final List<DateTime> dates;

  ScrollableApp(this.heroText, this.dates, {Key key, this.tabs, this.body}) : super(key: key);

  double get expandedHeight => 120.0;
  bool get isSingleDate => dates.length == 1;

  @override
  _ScrollableAppState createState() => _ScrollableAppState();
}

class _ScrollableAppState extends State<ScrollableApp> {
  TabController tabController;
  DateTime selectedDate;

  void _updateDate() {
    selectedDate = widget.dates[tabController.index];
    if(this.mounted)
      setState(() {});
  }

  @override
  void initState() {
    selectedDate = widget.dates[0];
    super.initState();
  }

  @override
  void dispose() {
    tabController?.removeListener(_updateDate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tabController = DefaultTabController.of(context);
    tabController?.addListener(_updateDate);
    var scrollView = NestedScrollView(
        body: widget.body,
        headerSliverBuilder: (context, isScrolled) =>
        widget.isSingleDate ? [_appBar()] : [_appBar(), _scrollableTabs(context)]
    );
    return scrollView;
  }

  SliverPersistentHeader _scrollableTabs(BuildContext context) => SliverPersistentHeader(
    pinned: true,
    delegate: _SliverAppBarDelegate(TabBar(
      tabs: widget.tabs,
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.white,
      indicator: BubbleTabIndicator(
        indicatorHeight: 28.0,
        indicatorColor: Colors.white,
        tabBarIndicatorSize: TabBarIndicatorSize.tab,
      ),
    )),
  );

  SliverAppBar _appBar() {
    return SliverAppBar(
        elevation: 0.0,
        expandedHeight: widget.expandedHeight,
        pinned: true,
        title: HeroAppBarTitle(widget.heroText),
        flexibleSpace: FlexibleSpaceBar(
            background: CenterDateTitle(selectedDate),
            centerTitle: true
        )
    );
  }
}

class CenterDateTitle extends StatelessWidget {
  final DateTime current;
  const CenterDateTitle(this.current, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final day = Text('${current.day}', style: TextStyle(color: Colors.white, fontSize: 58.0));
    final weekday = Text('${formatFullWeekDay(current)}', style: TextStyle(color: Colors.white, fontSize: 22.0));
    final monthYear = Text('${formatFullMonth(current)} ${current.year}', style: TextStyle(color: Colors.white70, fontSize: 16.0));
    final padding = Padding(
      padding: EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          day,
          Padding(
            padding: const EdgeInsets.only(left: 6.0, bottom: 12.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[ weekday, monthYear ]
            ),
          )
        ]),
  );
    return padding;
  }
}

class HeroAppBarTitle extends StatelessWidget {
  final HeroText heroText;

  const HeroAppBarTitle(this.heroText, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Text('Розклад на '),
      _heroTextWrapper(context)
    ]
  );

  Widget _heroTextWrapper(context) => Hero(
        tag: heroText.tag,
        child: Material(
            color: Colors.transparent,
            textStyle: Theme.of(context).textTheme.title.copyWith(color: Colors.white),
            child: Text(heroText.text)
        )
  );
}

class ScheduleTimeline extends StatelessWidget {
  final SelectedData data;

  const ScheduleTimeline(this.data, {Key key}) : super(key: key);

  // TODO add timeline ui
  @override
  Widget build(BuildContext context) => ListView.builder(
        itemBuilder: (BuildContext context, int index) => Stack(
            children: <Widget>[
              _info()
            ],
          ),
        itemCount: 1,
      );

  Center _info() => Center(child: Text('${data.scheduleType} => ${data.selected}'));
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class SchedulePeriod {
  DateTime from;
  DateTime to;
  SchedulePeriod(this.from, this.to);

  @override
  String toString() => formatRangeDates(from, to);

  SchedulePeriod toUtc() => SchedulePeriod(DateTime.utc(from.year, from.month, from.day), DateTime.utc(to.year, to.month, to.day));
}