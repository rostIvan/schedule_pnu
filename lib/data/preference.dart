import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefWrapper {
  static const GROUP_PREFERENCE_KEY = 'selectedGroup';
  static const TEACHER_PREFERENCE_KEY = 'selectedTeacher';

  Future<bool> isAuthenticated() async => ((await selectedGroup()) != null) || ((await selectedTeacher()) != null);

  Future<String> selectedGroup() async {
    var sharedPreference = await getPrefInstance();
    return sharedPreference.get(GROUP_PREFERENCE_KEY);
  }

  Future<bool> selectGroup(String group) async {
    var sharedPreference = await getPrefInstance();
    sharedPreference.remove(TEACHER_PREFERENCE_KEY);
    return sharedPreference.setString(GROUP_PREFERENCE_KEY, group);
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