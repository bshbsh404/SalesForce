import 'package:cron/cron.dart';

class Scheduler {
  Scheduler._privateConstructor();
  static final Scheduler instance = Scheduler._privateConstructor();
  static final Cron lcron = new Cron();

  runScheduler(cron, fn) {
    lcron.schedule(new Schedule.parse(cron), () async {
      fn();
    });
  }
}
