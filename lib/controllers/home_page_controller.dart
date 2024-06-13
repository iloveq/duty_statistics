import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bruno/bruno.dart';
import 'package:duty_statistics/pojo/pojo.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as cell;

import '../provider/holiday_data_provider.dart';
import '../router/app_pages.dart';
import '../utils/duty_utils.dart';
import '../utils/save_file_mobile_desktop.dart'
    if (dart.library.html) '../utils/save_file_web.dart' as helper;

class HomePageController extends GetxController {
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  late DateTime firstDate;
  late DateTime lastDate;
  var yearMonthSelectedStrObs = "".obs;
  var selectedHolidayStrObs = "".obs;
  var selectedYear = 2024;
  var selectedMonth = 1;
  var selectedHoliday = <DateTime>[];
  var userList = <User>[].obs;
  var curMonthDayList = <Date>[];
  var isLoading = false.obs;
  var isScheduling = false;
  var userListCopy = <User>[];
  var curMonthDayListCopy = <Date>[];

  @override
  void onInit() async {
    super.onInit();
    yearMonthSelectedStrObs.listen((i) {
      var yearMonthArr = i.split("-");
      selectedYear = int.parse(yearMonthArr[0]);
      selectedMonth = int.parse(yearMonthArr[1]);
      // init
      firstDate = DateTime(selectedYear, selectedMonth, 1);
      lastDate = DateTime(selectedYear, selectedMonth,
          DateTime(selectedYear, selectedMonth + 1, 0).day);
      // get holiday
      selectHolidayAuto(selectedYear, selectedMonth);
    });
    selectedHolidayStrObs.listen((i) {
      if (selectedHoliday.isNotEmpty) {
        curMonthDayList = getMonthCalendar(selectedYear, selectedMonth,
            holidays: selectedHoliday);
      }
    });
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;
    // 打印当前日期
    print('当前日期是：$year年$month月$day日');
    yearMonthSelectedStrObs.value = "$year-$month";
  }

  void selectHolidayAuto(int year, int month) async {
    var holidayDataResp = await HolidayDataProvider().getHoliday(year, month);
    print(holidayDataResp);
    if (!holidayDataResp.isOk) {
      return;
    }
    var holidayData = holidayDataResp.body;
    print(holidayData);
    if (holidayData == null) {
      return;
    }
    if (holidayData.isEmpty) {
      print("****");
      selectedHolidayStrObs.value = "";
      return;
    }
    if (holidayData.isNotEmpty) {
      selectedHoliday.clear();
      for (var e in holidayData) {
        // status: 0普通工作日1周末双休日2需要补班的工作日3法定节假日
        if (e.status == 1 || e.status == 3) {
          selectedHoliday.add(DateTime(e.year, e.month, e.day));
        }
      }
      if (selectedHoliday.isNotEmpty) {
        selectedHolidayStrObs.value = convertDateTimeList2Str(selectedHoliday);
      }
    }
  }

  void generateSchedule(BuildContext context) {
    var holidayCount = 0;
    var workdayCount = 0;
    if (userList.isEmpty) {
      BrnToast.show(
        "error 请倒入值班人",
        context,
      );
      return;
    }
    var holidaySelectedCount = selectedHoliday.length;
    if (holidaySelectedCount == 0) {
      BrnToast.show(
        "error 请选择休息日并确认",
        context,
      );
    }

    for (var e in userList) {
      holidayCount += e.holidaySchedulingNum;
      workdayCount += e.workdaySchedulingNum;
    }
    if (holidayCount != holidaySelectedCount) {
      BrnToast.show(
        "error 请核对周末排班：节假日排班数 $holidayCount 不等于节假日总天数 ${selectedHoliday.length}",
        context,
      );
      return;
    }

    if (workdayCount != curMonthDayList.length - selectedHoliday.length) {
      BrnToast.show(
        "error 请核对平常排班：节假日排班数 $workdayCount 不等于节假日总天数 ${curMonthDayList.length - selectedHoliday.length}",
        context,
      );
      return;
    }

    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    userListCopy.clear();
    userListCopy = userList.map((e) => User.copyFrom(e)).toList();
    print("排版表：$userListCopy");
    var exceptionUser = userListCopy.firstWhereOrNull((e) =>
        e.noScheduleDay.firstWhereOrNull(
          (day) => day > curMonthDayList.last.day,
        ) !=
        null);
    if (exceptionUser != null) {
      BrnToast.show(
        "error 值班人：$exceptionUser 不值班日期含有超过本月最大日期 ${curMonthDayList.last.day}",
        context,
      );
      isLoading.value = false;
      return;
    }
    curMonthDayListCopy.clear();
    curMonthDayListCopy = curMonthDayList.map((e) => Date.copyFrom(e)).toList();
    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (!isLoading.value) {
        return;
      }
      if (isScheduling) {
        return;
      }
      isScheduling = true;
      bool isNeedRetry = doSchedule();
      isScheduling = false;
      if (!isNeedRetry) {
        Get.toNamed(Routes.second);
        isLoading.value = false;
        timer.cancel();
      }
    });
  }

  bool doSchedule() {
    bool needRetry = false;
    for (var e in curMonthDayListCopy) {
      e.clear();
    }
    for (var e in userListCopy) {
      e.clear();
    }
    userListCopy.shuffle(Random());
    for (var date in curMonthDayListCopy) {
      if (date.user != null) {
        continue;
      }
      for (var user in userListCopy) {
        if (user.isComplete) {
          continue;
        }
        isHitUser(user, date);
      }
      userListCopy.shuffle(Random());
    }
    for (var e in curMonthDayListCopy) {
      print(
          '${e.month}月${e.day}日 -- ${e.isHoliday ? "休息" : "周${e.week}"} --  值班人 -- '
          '${e.user?.name} ');
      if (e.user == null) {
        needRetry = true;
        break;
      }
    }
    return needRetry;
  }

  Future<void> exportDataGridToExcel() async {
    final cell.Workbook workbook = cell.Workbook();
    final cell.Worksheet worksheet = workbook.worksheets[0];
    key.currentState!.exportToExcelWorksheet(
      worksheet,
      cellExport: (details) {
        if (details.cellType == DataGridExportCellType.row) {
          Date date = details.cellValue as Date;
          details.excelRange.numberFormat = 'y-mm-d';
          details.excelRange.cellStyle = cell.CellStyle(workbook)
            ..backColorRgb = date.isHoliday ? Colors.amber : Colors.white
            ..hAlign = cell.HAlignType.center
            ..vAlign = cell.VAlignType.center;
          details.excelRange.value = date.user == null
              ? ""
              : "${date.month}.${date.day} - ${date.user?.name}";
        }
      },
    );
    final List<int> bytes = workbook.saveAsStream();
    await helper.saveAndLaunchFile(
        bytes, '$selectedYear年$selectedMonth月排班.xlsx');
    workbook.dispose();
  }

  void importLocalExcelAndParse() async {
    userList.clear();
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files[0];
        Uint8List? bytes;
        if (file.bytes?.isNotEmpty == true) {
          bytes = file.bytes;
        } else if (file.path?.isNotEmpty == true) {
          bytes = await File(file.path!).readAsBytes();
        }
        if (bytes?.isNotEmpty == true) {
          var excel = Excel.decodeBytes(bytes!);
          for (var table in excel.tables.keys) {
            print(table);
            var sheet = excel.tables[table]!;
            for (var row in excel.tables[table]!.rows) {
              print("$row");
              if (row.length < 4) {
                continue;
              }
              if (row[0] == null) {
                continue;
              }
              var row0 = sheet.cell(row[0]!.cellIndex);
              print("$row0");
              if (row0.value.toString() == "总计") {
                continue;
              }
              var row1 = sheet.cell(row[1]!.cellIndex);
              var row2 = sheet.cell(row[2]!.cellIndex);
              var row3 = sheet.cell(row[3]!.cellIndex);
              var row4 = row[4]?.cellIndex == null
                  ? null
                  : sheet.cell(row[4]!.cellIndex);
              userList.add(
                User(
                    name: row0.value.toString(),
                    workdaySchedulingNum: int.parse(row1.value.toString()),
                    holidaySchedulingNum: int.parse(row2.value.toString()),
                    noScheduleDay: getNoScheduleDateStrList(
                        row4?.value == null ? "" : row4!.value.toString())),
              );
            }
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
    print(userList);
  }
}
