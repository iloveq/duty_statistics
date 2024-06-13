import 'package:bruno/bruno.dart';
import 'package:duty_statistics/pojo/pojo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../controllers/home_page_controller.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late HomePageController controller;
  late DateSource source;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomePageController>();
    source = DateSource(dateList: controller.curMonthDayListCopy);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: BrnAppBar(
            //默认显示返回按钮
            automaticallyImplyLeading: true,
            themeData: BrnAppBarConfig.light(),
            title: '排班信息',
            //自定义的右侧文本
            actions: BrnTextAction(
              '导出excel',
              //设置为深色背景，则显示白色
              themeData: BrnAppBarConfig.light(),
              iconPressed: () {
                  controller.exportDataGridToExcel();
              },
            ),
          ),
          body: SfDataGrid(
            key: controller.key,
            source: source,
            columnWidthMode: ColumnWidthMode.fill,
            columns: <GridColumn>[
              GridColumn(
                columnName: '一',
                label: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.white70,
                  alignment: Alignment.center,
                  child: const Text('一'),
                ),
              ),
              GridColumn(
                columnName: '二',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white70,
                  alignment: Alignment.center,
                  child: const Text('二'),
                ),
              ),
              GridColumn(
                columnName: '三',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white70,
                  alignment: Alignment.center,
                  child: const Text('三'),
                ),
              ),
              GridColumn(
                columnName: '四',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white70,
                  alignment: Alignment.center,
                  child: const Text(
                    '四',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              GridColumn(
                columnName: '五',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white70,
                  alignment: Alignment.center,
                  child: const Text(
                    '五',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              GridColumn(
                columnName: '六',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white70,
                  alignment: Alignment.center,
                  child: const Text(
                    '六',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              GridColumn(
                columnName: '日',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white70,
                  alignment: Alignment.center,
                  child: const Text(
                    '日',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DateSource extends DataGridSource {
  List<DataGridRow> data = [];
  List<List<Date>> weeks = [];

  DateSource({required List<Date> dateList}) {
    if (dateList.length < 28) {
      return;
    }
    int a = dateList.first.week;
    int b = dateList.last.week;
    if (a != 1) {
      List<Date> t = [
        for (var i = 1; i <= a - 1; i++) Date(year: 0, month: 0, day: 0,isHoliday: false)
      ];
      dateList.insertAll(0, t);
    }
    if (b != 7) {
      List<Date> t = [
        for (var i = 1; i <= 7 - b; i++) Date(year: 0, month: 0, day: 0,isHoliday: false)
      ];
      dateList.insertAll(dateList.length, t);
    }

    for (int i = 0; i < dateList.length; i += 7) {
      int endIndex = i + 7;
      if (endIndex > dateList.length) {
        endIndex = dateList.length;
      }
      weeks.add(dateList.sublist(i, endIndex));
    }

    data = weeks
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<Date>(
                columnName: '一',
                value: e[0],
              ),
              DataGridCell<Date>(
                columnName: '二',
                value: e[1],
              ),
              DataGridCell<Date>(
                columnName: '三',
                value: e[2],
              ),
              DataGridCell<Date>(
                columnName: '四',
                value: e[3],
              ),
              DataGridCell<Date>(
                columnName: '五',
                value: e[4],
              ),
              DataGridCell<Date>(
                columnName: '六',
                value: e[5],
              ),
              DataGridCell<Date>(
                columnName: '日',
                value: e[6],
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => data;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        Date date = e.value as Date;
        if (date.week == 0) {
          return const SizedBox(
            width: 0,
            height: 0,
          );
        }
        return Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: date.isHoliday ? Colors.amber : Colors.white,
            border: Border.all(
              color: Colors.grey, // 边框颜色
              width: 0.5, // 边框宽度
            ),
          ),
          alignment: Alignment.center,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3, top: 3),
                  child: Text(
                    "${date.month}.${date.day}",
                    style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 8),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 3, top: 3),
                  child: Text(
                    date.isHoliday ? "休" : "",
                    style: const TextStyle(color: Colors.red, fontSize: 8),
                  ),
                ),
              ),
              Center(
                child: Text(
                  date.user?.name ?? "x",
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
