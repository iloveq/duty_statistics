
import 'package:flutter/material.dart';
import 'package:tw_calendar/tw_calendar.dart';

class CustomCalendarWidget extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final List<DateTime> selectedDate;
  final ValueChanged<List<DateTime>> onConfirmed;
  const CustomCalendarWidget({
    Key? key,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  CustomCalendarWidgetState createState() => CustomCalendarWidgetState();
}

class CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  late TWCalendarController controller;

  @override
  void initState() {
    super.initState();
    controller = TWCalendarController(
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      notSerialSelectedDates: widget.selectedDate,
      onSelectFinish: (selectStartTime, selectEndTime, notSerialSelectedTimes) {
        if(notSerialSelectedTimes?.isNotEmpty == true){
          print(notSerialSelectedTimes);
          widget.onConfirmed(notSerialSelectedTimes!);
        }
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TWCalendarList(
      calendarController: controller,
      configs: TWCalendarConfigs(
        listConfig: TWCalendarListConfig(
          selectedMode: TWCalendarListSelectedMode.notSerial,
        ),
        monthViewConfig: TWCalendarMonthViewConfig(
          monthBodyHeight: 300,
          canSelectedToday: true,
        ),
      ),
      headerView: Container(
        alignment: Alignment.center,
        height: 55,
        child: const Text(
          "请选择日期",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}