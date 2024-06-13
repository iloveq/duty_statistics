import 'package:duty_statistics/pages/second_page.dart';
import 'package:duty_statistics/pages/unknown_page.dart';
import 'package:get/get.dart';

import '../pages/home_page.dart';
import '../pages/third_page.dart';
part 'app_routers.dart';

class AppPages {

  static final routes = [
    GetPage(name: Routes.unknown, page: () => const UnknownPage()),
    GetPage(name: Routes.home, page: () => const HomePage()),
    GetPage(name: Routes.second, page: () => const SecondPage()),
    GetPage(name: Routes.third, page: () => const ThirdPage()),
    GetPage(name: Routes.login, page: () => const UnknownPage()),
  ];

  static final unknownPage = routes[0];
}