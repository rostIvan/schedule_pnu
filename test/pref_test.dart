
import 'package:flutter/services.dart';
import 'package:lessons_schedule_pnu/data/preference.dart';
import 'package:test/test.dart';

void main() async {
  final sharedPref = SharedPrefWrapper();
  setUp(() {
    const MethodChannel('plugins.flutter.io/shared_preferences').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll')
        return <String, dynamic>{}; // set initial values here if desired
      return null;
    });
    sharedPref.clear();
  });

  test('Shared preference save group', () async {
    await sharedPref.selectGroup('ІПЗ-1');
    var group = await sharedPref.selectedGroup();
    var teacher = await sharedPref.selectedTeacher();
    expect(group, 'ІПЗ-1');
    expect(teacher, null);
  });

  test('Shared preference save teacher', () async {
    await sharedPref.selectTeacher('Козленко');
    var teacher = await sharedPref.selectedTeacher();
    var group = await sharedPref.selectedGroup();
    expect(teacher, 'Козленко');
    expect(group, null);
  });

  test('Shared preference authentificated flag', () async {
    expect((await sharedPref.isAuthenticated()), false);
    await sharedPref.selectTeacher('Іщеряков');
    expect((await sharedPref.isAuthenticated()), true);
    await sharedPref.selectGroup('ІПЗ-2');
    expect((await sharedPref.isAuthenticated()), true);
    await sharedPref.clear();
    expect((await sharedPref.isAuthenticated()), false);
  });
}