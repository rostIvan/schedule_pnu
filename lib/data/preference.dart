import 'dart:async';

import 'package:lessons_schedule_pnu/util/support.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedData {
  final ScheduleType scheduleType;
  final String selected;
  SelectedData(this.scheduleType, this.selected);
}

class SharedPrefWrapper {
  static const GROUP_PREFERENCE_KEY = 'selectedGroup';
  static const TEACHER_PREFERENCE_KEY = 'selectedTeacher';

  Future<bool> isAuthenticated() async => ((await selectedGroup()) != null) || ((await selectedTeacher()) != null);

  Future<SelectedData> selectedData() async {
    var group = await selectedGroup();
    var teacher = await selectedTeacher();
    if (group != null)
      return SelectedData(ScheduleType.GROUP, group);
    else if(teacher != null)
      return SelectedData(ScheduleType.TEACHER, teacher);
    else
      throw Exception('Selected group and teacher are null, please firstly check it using method "isAuthenticated()"');
  }

  Future<String> selectedGroup() async {
    var sharedPreference = await getPrefInstance();
    return sharedPreference.get(GROUP_PREFERENCE_KEY);
  }

  Future<bool> selectGroup(String group) async {
    var sharedPreference = await getPrefInstance();
    sharedPreference.remove(TEACHER_PREFERENCE_KEY);
    return sharedPreference.setString(GROUP_PREFERENCE_KEY, group);
  }

  Future<bool> select(ScheduleType type, String value) async {
    if(type == ScheduleType.GROUP)
      return selectGroup(value);
    else if(type == ScheduleType.TEACHER)
      return selectTeacher(value);
    return null;
  }

  Future<String> selectedTeacher() async {
    var sharedPreference = await getPrefInstance();
    return sharedPreference.get(TEACHER_PREFERENCE_KEY);
  }

  Future<bool> selectTeacher(String teacher) async {
    var sharedPreference = await getPrefInstance();
    sharedPreference.remove(GROUP_PREFERENCE_KEY);
    return sharedPreference.setString(TEACHER_PREFERENCE_KEY, teacher);
  }

  Future<bool> clear() => getPrefInstance().then((sharedPreferences) {
      sharedPreferences.remove(GROUP_PREFERENCE_KEY);
      sharedPreferences.remove(TEACHER_PREFERENCE_KEY);
  });

  Future<SharedPreferences> getPrefInstance() async => await SharedPreferences.getInstance();
}