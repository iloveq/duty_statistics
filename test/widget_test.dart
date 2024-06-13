// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:duty_statistics/pojo/pojo.dart';
import 'package:duty_statistics/utils/duty_utils.dart';

void main() async {
  // init
  List<User> userList = [
    User(
      name: "蕊",
      workdaySchedulingNum: 2,
      holidaySchedulingNum: 1,
      noScheduleDay: [],
    ),
    User(
      name: "涓",
      workdaySchedulingNum: 2,
      holidaySchedulingNum: 1,
      noScheduleDay: [],
    ),
    User(
      name: "航",
      workdaySchedulingNum: 2,
      holidaySchedulingNum: 0,
      noScheduleDay: [],
    ),
    User(
      name: "媚",
      workdaySchedulingNum: 2,
      holidaySchedulingNum: 1,
      noScheduleDay: [],
    ),
    User(
      name: "吴",
      workdaySchedulingNum: 2,
      holidaySchedulingNum: 0,
      noScheduleDay: [],
    ),
    User(
      name: "旻",
      workdaySchedulingNum: 1,
      holidaySchedulingNum: 2,
      noScheduleDay: [],
    ),
    User(
      name: "邓",
      workdaySchedulingNum: 1,
      holidaySchedulingNum: 1,
      noScheduleDay: [],
    ),
    User(
      name: "姜",
      workdaySchedulingNum: 2,
      holidaySchedulingNum: 1,
      noScheduleDay: [],
    ),
    User(
      name: "于",
      workdaySchedulingNum: 2,
      holidaySchedulingNum: 1,
      noScheduleDay: [],
    ),
    User(
      name: "宋",
      workdaySchedulingNum: 1,
      holidaySchedulingNum: 2,
      noScheduleDay: [],
    ),
    User(
      name: "叶",
      workdaySchedulingNum: 2,
      holidaySchedulingNum: 1,
      noScheduleDay: [],
    ),
  ];
  List<Date> curMonthDayList = getMonthCalendar(
    2024,
    6,
  );
  // List<List<Date>> workdayGroup = [];
  // List<List<Date>> holidayGroup = [];
  //
  // List<Date> workdayList = curMonthDayList.where((e) => !e.isHoliday).toList();
  // List<Date> holidayList = curMonthDayList.where((e) => e.isHoliday).toList();
  //
  // group(workdayGroup, workdayList);
  // group(holidayGroup, holidayList);

  // var user = randomWhere<User>(
  //     userList, condition: (e) =>  e.allSchedulingNum == 3);
  // while (userList.isNotEmpty) {
  //   while (!user.isComplete) {
  //     for (var date in curMonthDayList) {
  //       isHitUser(user, date);
  //     }
  //   }
  //   userList.remove(user);
  //   if (userList.length == 1) {
  //     user = userList.first;
  //     print(user);
  //     break;
  //   }
  //   print(userList.length);
  //   user = randomWhere<User>(userList);
  // }
  //
  // // if(curMonthDayList.length<28){
  // //   return;
  // // }
  // // int a = curMonthDayList.first.week;
  // // int b = curMonthDayList.last.week;
  // // if(a!=1){
  // //   List<Date> t = [
  // //     for (var i = 1; i <= a-1; i++) Date(year: 0, month: 0, day: 0)
  // //   ];
  // //   curMonthDayList.insertAll(0, t);
  // // }
  // // if(b!=7){
  // //   List<Date> t = [
  // //     for (var i = 1; i <= 7-b; i++) Date(year: 0, month: 0, day: 0)
  // //   ];
  // //   curMonthDayList.insertAll(curMonthDayList.length, t);
  // // }

  // bool doSchedule() {
  //   int a = DateTime.now().millisecond;
  //   bool needRetry = false;
  //   for (var e in curMonthDayList) {
  //     e.clear();
  //   }
  //   for (var e in userList) {
  //     e.clear();
  //   }
  //   userList.shuffle(Random());
  //   for (var date in curMonthDayList) {
  //     if(date.user != null){
  //       continue;
  //     }
  //     for(var user in userList){
  //       if(user.isComplete){
  //         continue;
  //       }
  //       isHitUser(user, date);
  //     }
  //     userList.shuffle(Random());
  //   }
  //   for (var e in curMonthDayList) {
  //     if(e.user == null){
  //       needRetry = true;
  //       break;
  //     }
  //     print(
  //         '${e.month}月${e.day}日 -- ${e.isHoliday ? "休息" : "周${e.week}"} --  值班人 -- '
  //             '${e.user?.name} ');
  //   }
  //   int b = DateTime.now().millisecond;
  //   // print(" --- ${b-a}");
  //   return needRetry;
  // }
  //
  // bool isNeedRetry = true;
  // while(isNeedRetry){
  //   isNeedRetry = doSchedule();
  // }
  //
  // for(var u in userList){
  //   if(!u.isComplete){
  //     print("值班人 -- ${u.name} 工作日 --${u.workdaySchedulingNum-u.scheduledWorkDayList.length} 工作日 --${u.holidaySchedulingNum-u.scheduledHolidayList.length}");
  //   }
  // }

  // List<int> originalList = List.generate(100, (index) => index); // 示例列表
  // List<List<int>> subLists = []; // 存储截取后的子列表
  //
  // for (int i = 0; i < originalList.length; i += 7) {
  //   int endIndex = i + 7;
  //   if (endIndex > originalList.length) {
  //     endIndex = originalList.length;
  //   }
  //   subLists.add(originalList.sublist(i, endIndex));
  // }
  //
  // print(subLists); // 打印结果

  // List<int> list = [1, 2, 3, 4, 5];
  // Random random = Random();
  //
  // userList.shuffle(random);
  //
  // print(userList);
  String str = 'axx，bx，x,,cx,xx,,，，,,dxx,e';
  List<String> result =
      str.split(RegExp(r',|，')).where((e) => e.isNotEmpty).toList();
  print(result); // 输出: [axx, bxx, cxx, dxx, e]
}
