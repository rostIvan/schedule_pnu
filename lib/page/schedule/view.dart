import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
import 'package:lessons_schedule_pnu/page/home/cards.dart';
import 'package:lessons_schedule_pnu/util/date.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class SchedulePage extends StatefulWidget {
  final SelectedData data;
  final HeroText heroText;
  final DateTime dateTime;
  final SchedulePeriod period;
  const SchedulePage(this.data, {Key key, this.dateTime, this.period, this.heroText}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage>  {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.dateTime != null) {
      return SingleDateSchedule(widget.data, widget.dateTime, widget.heroText);
    }
    else if(widget.period != null) {
      return RangeDateSchedule(widget.data, widget.period, widget.heroText);
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
    body: ScrollableApp(heroText, body: ScheduleTimeline(data)),
  );
}

class RangeDateSchedule extends StatelessWidget {
  final SelectedData data;
  final SchedulePeriod period;
  final HeroText heroText;
  const RangeDateSchedule(this.data, this.period, this.heroText, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tabs =  _tabs();
    return DefaultTabController(length: tabs.length, child: Scaffold(
      body: ScrollableApp(
          heroText,
          tabs: _tabs(),
          body: TabBarView(children: List.generate(tabs.length, (i) => ScheduleTimeline(data)))
      ),
    ));
  }

  List<Widget> _tabs() {
    final utcPeriod = period.toUtc();
    final start = utcPeriod.from;
    final end = utcPeriod.to;
    final datesTabs = dateRange(start, end)
        .map((date) => Tab(child: Text(formatSingleDate(date))))
        .toList();
    return datesTabs;
  }
}

class ScrollableApp extends StatefulWidget {
  final Widget body;
  final HeroText heroText;
  final List<Widget> tabs;
  ScrollableApp(this.heroText, {Key key, this.body, this.tabs}) : super(key: key);
  @override
  _ScrollableAppState createState() => _ScrollableAppState();
}

class _ScrollableAppState extends State<ScrollableApp> {
  int counter = 1;
  double get expandedHeight => 120.0;

  @override
  void initState() {
    super.initState();
    if(widget.tabs != null)
      Future.delayed(Duration.zero, () {
        var tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          print('index: ${tabController.index}');
          setState(() {
            counter = tabController.index + 1;
          });
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.tabs == null) return NestedScrollView(
        body: widget.body,
        headerSliverBuilder: (context, isScrolled) => [_appBar()]
    );
    return NestedScrollView(
        body: widget.body,
        headerSliverBuilder: (context, isScrolled) => [_appBar(), _scrollableTabs()]
    );
  }

  SliverPersistentHeader _scrollableTabs() {
    return SliverPersistentHeader(
        delegate: _SliverAppBarDelegate(TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.white,
            indicator: new BubbleTabIndicator(
                indicatorHeight: 28.0,
                indicatorColor: Colors.white,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            tabs: widget.tabs,
            isScrollable: true
        )),
        pinned: true,
      );
  }

  SliverAppBar _appBar() {
    return SliverAppBar(
        elevation: 0.0,
        expandedHeight: expandedHeight,
        pinned: true,
        title: HeroAppBarTitle(widget.heroText),
        flexibleSpace: FlexibleSpaceBar(
            background: _titleWidget(),
            centerTitle: true
        )
      );
  }

  Widget _titleWidget() => Padding(
    padding: EdgeInsets.all(6.0),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
        Text('$counter', style: TextStyle(color: Colors.white, fontSize: 58.0)),
        Padding(
          padding: const EdgeInsets.only(left: 6.0, bottom: 12.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Wednesday', style: TextStyle(color: Colors.white, fontSize: 22.0)),
                Text('September 2018', style: TextStyle(color: Colors.white70, fontSize: 16.0))
          ]),
        )
      ]),
  );
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
  @override
  Widget build(BuildContext context) => Center(
      child: Text('${data.scheduleType} => ${data.selected}')
  );
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