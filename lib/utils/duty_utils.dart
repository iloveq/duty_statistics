import 'dart:math';

import '../pojo/pojo.dart';

List<int> getNoScheduleDateStrList(String str) {
  if (str == "") {
    return [];
  }
  return str
      .split(RegExp(r',|，'))
      .where((e) => e.isNotEmpty)
      .map((e) => int.parse(e))
      .toList();
}

bool isHitUser(User user, Date date) {
  if (date.user != null) {
    return false;
  }
  // x 号不排
  if (user.noScheduleDay.isNotEmpty && user.noScheduleDay.contains(date.day)) {
    return false;
  }
  // 本月已完成值班
  if (user.isComplete) {
    return false;
  }
  for (var e in user.scheduledWorkDayList) {
    // 星期 x 已值
    if (date.week <= 5 && date.week == e.week) {
      return false;
    }
    // 值过的平时不要同一周 周末和平时尽量不在一周
    if (isSameWeek(date.dataTime, e.dataTime)) {
      return false;
    }
  }

  // for (var e in user.scheduledAllList) {
  //   // 值过的平时不要同一周 周末和平时尽量不在一周
  //   if (isSameWeek(date.dataTime, e.dataTime)) {
  //     return false;
  //   }
  // }

  if (user.scheduledAllList.isNotEmpty) {
    // 间隔3天
    if (date.day - user.scheduledAllList.last.day <= 2) {
      return false;
    }
  }

  // 排班
  if (date.isHoliday) {
    if (user.isCompleteHolidayScheduling) {
      return false;
    }
  } else {
    if (user.isCompleteWorkdayScheduling) {
      return false;
    }
  }
  // 排班
  if (date.isHoliday) {
    user.scheduledHolidayList.add(date);
  } else {
    user.scheduledWorkDayList.add(date);
  }
  user.scheduledAllList.add(date);
  date.user = user;
  return true;
}

String convertDateTimeList2Str(List<DateTime> value) {
  var s = "";
  for (var date in value) {
    s += "${date.month}.${date.day} ";
  }
  return s;
}

void group(List<List<Date>> group, List<Date> list) {
  for (int i = 0; i < list.length;) {
    Date num = list[i];
    int j = i + 1;
    while (j < list.length && list[j].day == num.day + 1) {
      num = list[j];
      j++;
    }
    group.add(list.sublist(i, j));
    i = j;
  }
}

bool isSameWeek(DateTime day1, DateTime day2) {
  DateTime startOfWeek1 = day1.subtract(Duration(days: day1.weekday - 1));
  DateTime startOfWeek2 = day2.subtract(Duration(days: day2.weekday - 1));
  return startOfWeek1 == startOfWeek2;
}

T randomWhere<T>(List<T> list, {bool Function(T)? condition}) {
  Random random = Random();
  int index = random.nextInt(list.length);
  T t = list[index];
  if (condition == null) {
    return t;
  }
  while (true) {
    if (condition.call(t)) {
      break;
    } else {
      index = random.nextInt(list.length);
      t = list[index];
    }
  }
  return t;
}

List<Date> getMonthCalendar(int year, int month, {List<DateTime>? holidays}) {
  List<Date> calendar = [];
  int daysInMonth = DateTime(year, month + 1, 0).day;
  // 遍历该月的所有日期
  for (int i = 1; i <= daysInMonth; i++) {
    DateTime day = DateTime(year, month, i);
    var isHoliday = false;
    if (holidays?.isNotEmpty == true) {
      isHoliday = holidays!.contains(day);
    }
    calendar.add(Date(
      year: year,
      month: month,
      day: i,
      isHoliday: isHoliday,
    ));
  }

  return calendar;
}
