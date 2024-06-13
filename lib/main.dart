import 'package:bruno/bruno.dart';
import 'package:duty_statistics/controllers/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'l10n.dart';
import 'router/app_pages.dart';

void main() {
  BrnIntl.add(ResourceDe.locale, ResourceDe());

  Get.put<HomePageController>(HomePageController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ChangeLocalEvent>(
      onNotification: (_) {
        setState(() {});
        return true;
      },
      child: GetMaterialApp(
        // 初始路径
        initialRoute: Routes.home,
        // 404页面
        unknownRoute: AppPages.unknownPage,
        // 中间件
        routingCallback: (routing) {
          if (routing?.current == Routes.login) {
            Get.to(Routes.login);
          }
        },
        theme: ThemeData(useMaterial3: false),
        locale: ChangeLocalEvent.locale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          BrnLocalizationDelegate.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('zh', 'CN'),
          Locale('de', 'DE'),
        ],
        // 路由配置表
        getPages: AppPages.routes,
      ),
    );
  }
}
