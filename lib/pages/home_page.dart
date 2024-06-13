import 'package:bruno/bruno.dart';
import 'package:duty_statistics/controllers/home_page_controller.dart';
import 'package:duty_statistics/pojo/pojo.dart';
import 'package:duty_statistics/utils/duty_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../common/constants.dart';
import '../widget/custom_calendar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomePageController>();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: BrnAppBar(
            //默认显示返回按钮
            automaticallyImplyLeading: false,
            themeData: BrnAppBarConfig.light(),
            title: '排班信息',
            //自定义的右侧文本
            actions: BrnTextAction(
              '生成排班',
              //设置为深色背景，则显示白色
              themeData: BrnAppBarConfig.light(),
              iconPressed: () {
                controller.generateSchedule(context);
              },
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: <Widget>[
                  Obx(
                    () => BrnTextSelectFormItem(
                      isRequire: true,
                      value: controller.yearMonthSelectedStrObs.value,
                      title: "选择排班年/月",
                      onTap: () {
                        BrnMultiDataPicker(
                          sync: false,
                          context: context,
                          title: '请选择日期',
                          delegate: Brn2RowDelegate(
                            firstSelectedIndex: yearOptionList
                                .indexOf("${controller.selectedYear}"),
                            secondSelectedIndex: monthOptionList
                                .indexOf("${controller.selectedMonth}"),
                          ),
                          confirmClick: (list) {
                            controller.yearMonthSelectedStrObs.value =
                                "${yearOptionList[list[0]]}-${monthOptionList[list[1]]}";
                            // BrnToast.show(list.toString(), context);
                          },
                        ).show();
                      },
                    ),
                  ),
                  Obx(
                    () => BrnTextSelectFormItem(
                      isRequire: true,
                      title: "设置休息日",
                      value: controller.selectedHolidayStrObs.value,
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return CustomCalendarWidget(
                              firstDate: controller.firstDate,
                              lastDate: controller.lastDate,
                              selectedDate: controller.selectedHoliday,
                              onConfirmed: (List<DateTime> value) {
                                controller.selectedHoliday = value;
                                print(controller.selectedHoliday);
                                controller.selectedHolidayStrObs.value =
                                    convertDateTimeList2Str(value);
                                print(controller.selectedHolidayStrObs.value);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  BrnTextSelectFormItem(
                    isRequire: true,
                    title: "值班人 excel",
                    hint: "点击本地导入",
                    onTap: () {
                      controller.importLocalExcelAndParse();
                    },
                  ),
                  Obx(
                    () => controller.userList.value.isNotEmpty == true
                        ? Expanded(
                            child: SfDataGrid(
                              source:
                                  UserDataSource(users: controller.userList),
                              columnWidthMode: ColumnWidthMode.fill,
                              columns: <GridColumn>[
                                GridColumn(
                                  columnName: '姓名',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: const Text('姓名'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: '平常',
                                  label: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: const Text('平常'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: '休息',
                                  label: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: const Text('休息'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: '不值班日期',
                                  label: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      '不值班日期',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          ),
                  ),
                ],
              ),
              Obx(
                () => controller.isLoading.value
                    ? const Center(
                        child: BrnPageLoading(
                          content: "生成中。。",
                        ),
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}

class UserDataSource extends DataGridSource {
  List<DataGridRow> data = [];

  UserDataSource({required List<User> users}) {
    data = users
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: '姓名',
                value: e.name,
              ),
              DataGridCell<int>(
                columnName: '平常',
                value: e.workdaySchedulingNum,
              ),
              DataGridCell<int>(
                columnName: '休息',
                value: e.holidaySchedulingNum,
              ),
              DataGridCell<String>(
                columnName: '不值班日期',
                value: e.noScheduleDay.toString(),
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
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

class Brn2RowDelegate implements BrnMultiDataPickerDelegate {
  int firstSelectedIndex = 0;
  int secondSelectedIndex = 0;

  Brn2RowDelegate({this.firstSelectedIndex = 0, this.secondSelectedIndex = 0});

  @override
  int numberOfComponent() {
    return 2;
  }

  @override
  int numberOfRowsInComponent(int component) {
    if (0 == component) {
      return yearOptionList.length;
    } else {
      return monthOptionList.length;
    }
  }

  @override
  String titleForRowInComponent(int component, int index) {
    if (0 == component) {
      return yearOptionList[index];
    } else {
      return monthOptionList[index];
    }
  }

  @override
  double? rowHeightForComponent(int component) {
    return null;
  }

  @override
  selectRowInComponent(int component, int row) {
    if (0 == component) {
      firstSelectedIndex = row;
    } else {
      secondSelectedIndex = row;
    }
  }

  @override
  int initSelectedRowForComponent(int component) {
    if (0 == component) {
      return firstSelectedIndex;
    }
    return secondSelectedIndex;
  }
}
