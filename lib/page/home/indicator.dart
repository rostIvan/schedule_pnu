import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  Circle({Key key, this.color, this.size, this.filled}) : super(key: key);

  final Color color;
  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: Border.all(
      color: Theme.of(context).primaryColor,
      width: 0.8,
    )),
  );
}

class PageIndicator extends StatefulWidget {
  final ValueNotifier<int> valueNotifier;
  final int length;
  final Widget normalIndicator;
  final Widget selectedIndicator;

  const PageIndicator({Key key, this.valueNotifier, this.length, this.normalIndicator, this.selectedIndicator}) : super(key: key);

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  int selectedIndicatorIndex = 0;

  @override
  void initState() {
    widget.valueNotifier.addListener(_changeIndicator);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Align(alignment: Alignment.centerRight,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildIndicators()
      )
  );

  void _changeIndicator() {
    setState(() {
      selectedIndicatorIndex = widget.valueNotifier.value;
    });
  }

  List<Widget> _buildIndicators() {
    var indicators = List.generate(widget.length - 1, (index) => widget.normalIndicator)
      ..insert(selectedIndicatorIndex, widget.selectedIndicator);
    return indicators.map((w) => Padding(child: w, padding: EdgeInsets.all(4.0))).toList();
  }
}

