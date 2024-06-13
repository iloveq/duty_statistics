class User {
  // 姓名
  String name;

  // 工作日排班数
  int workdaySchedulingNum;

  // 加假日排班数
  int holidaySchedulingNum;

  // 排班日期记录 1～7
  List<Date> scheduledWorkDayList;
  List<Date> scheduledHolidayList;
  List<Date> scheduledAllList;

  // x 号不排
  List<int> noScheduleDay;

  int get allSchedulingNum => workdaySchedulingNum + holidaySchedulingNum;

  bool get isComplete =>
      isCompleteWorkdayScheduling && isCompleteHolidayScheduling;

  bool get isCompleteWorkdayScheduling =>
      workdaySchedulingNum == scheduledWorkDayList.length;

  bool get isCompleteHolidayScheduling =>
      holidaySchedulingNum == scheduledHolidayList.length;

  void clear() {
    scheduledWorkDayList.clear();
    scheduledHolidayList.clear();
    scheduledAllList.clear();
  }

  User({
    required this.name,
    required this.workdaySchedulingNum,
    required this.holidaySchedulingNum,
    required this.noScheduleDay,
  })  : scheduledWorkDayList = [],
        scheduledHolidayList = [],
        scheduledAllList = [];

  User.copyFrom(User other)
      : this(
          name: other.name,
          workdaySchedulingNum: other.workdaySchedulingNum,
          holidaySchedulingNum: other.holidaySchedulingNum,
          noScheduleDay: other.noScheduleDay,
        );

  @override
  String toString() {
    return 'name： $name 工作日排班数：$workdaySchedulingNum '
        '休息日排班数：$holidaySchedulingNum 不值班日期列表：$noScheduleDay';
  }
}

class Date {
  int year;
  int month;

  // 日期 1-31
  int day;

  // 星期几 1-7
  int get week {
    if (year == 0 && month == 0 && day == 0) {
      return 0;
    } else {
      return dataTime.weekday;
    }
  }

  // 是否节假日
  bool isHoliday;

  // 当前排班
  User? user;

  DateTime get dataTime => DateTime(year, month, day);

  void clear() {
    user = null;
  }

  Date.copyFrom(Date other)
      : this(
          year: other.year,
          month: other.month,
          day: other.day,
          isHoliday: other.isHoliday,
        );

  Date({
    required this.year,
    required this.month,
    required this.day,
    required this.isHoliday,
  }) : user = null;
}

class HolidayBean {
  late String date;
  late int year;
  late int month;
  late int day;
  late int status;

  HolidayBean(
      {this.date = "",
      this.year = 0,
      this.month = 0,
      this.day = 0,
      this.status = 0});

  HolidayBean.fromJson(Map<String, dynamic> json) {
    date = json['date'] ?? "";
    year = json['year'] ?? 0;
    month = json['month'] ?? 0;
    day = json['day'] ?? 0;
    status = json['status'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['year'] = year;
    data['month'] = month;
    data['day'] = day;
    data['status'] = status;
    return data;
  }
}
