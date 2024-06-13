import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../router/app_pages.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BrnAppBar(
          //默认显示返回按钮
          automaticallyImplyLeading: true,
          themeData: BrnAppBarConfig.light(),
          title: '生成排班',
          //自定义的右侧文本
          actions: BrnTextAction(
            '点击生成',
            //设置为深色背景，则显示白色
            themeData: BrnAppBarConfig.light(),
            iconPressed: () {

            },
          ),
        )
      ],
    );
  }
}
