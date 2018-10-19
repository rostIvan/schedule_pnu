import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
import 'package:lessons_schedule_pnu/di/select.dart';
import 'package:lessons_schedule_pnu/page/preloader/logo.dart';
import 'package:lessons_schedule_pnu/page/selection/view.dart';
import 'package:lessons_schedule_pnu/util/support.dart';

class HomeDrawer extends StatelessWidget {
  final SelectedData data;

  HomeDrawer(this.data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(child:  ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
            currentAccountPicture: PnuAvatar(),
            otherAccountsPictures: <Widget>[ CircleAvatar(child: Text(_firstLetter())) ],
            accountEmail: Text(data.selected),
            accountName: _selectGroup() ? Text('Розклад для групи') : Text('Розклад для викладача')),
        DrawerItem('Змінити групу', Icons.group, onClick: () => _openSelectGroupPage(context)),
        DrawerItem('Змінити викладача', Icons.person, onClick: () => _openSelectTeacherPage(context)),
        DrawerItem('Порівняти розклад груп', Icons.compare, onClick: () => null),
        DrawerItem('Вихід', Icons.exit_to_app, onClick: () => exit(0)),
      ])
  );

  void _openSelectGroupPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SelectionPage(
        searchStore(ScheduleType.GROUP), searchInteractor(type: ScheduleType.GROUP)
    )));
  }

  void _openSelectTeacherPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SelectionPage(
        searchStore(ScheduleType.TEACHER), searchInteractor(type: ScheduleType.TEACHER)
    )));
  }

  bool _selectGroup() => data.scheduleType == ScheduleType.GROUP;
  String _firstLetter() => data.selected.split('')[0];
}

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onClick;
  DrawerItem(this.title, this.icon, {this.onClick});

  @override
  Widget build(BuildContext context) {
    var accentColor = Theme.of(context).accentColor;
    return Column(children: <Widget>[
      ListTile(title: Text(title, style: TextStyle(color: accentColor)), trailing: Icon(icon, color: accentColor), onTap: onClick),
      Divider(height: 1.0, color: Colors.grey[400])
    ]);
  }
}