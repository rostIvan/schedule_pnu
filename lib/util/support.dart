import 'dart:async';

enum ScheduleType {
  GROUP,
  TEACHER
}

class DebounceAction {
  Timer timer;

  void create(Duration duration, Function doDebounce) {
    if (timer != null) timer.cancel();
    timer = Timer(duration, doDebounce);
  }
}