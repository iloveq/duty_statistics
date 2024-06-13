import 'package:duty_statistics/pojo/pojo.dart';
import 'package:get/get.dart';

class HolidayDataProvider extends GetConnect {
  // https://api.haoshenqi.top/holiday?date=2024-6

  @override
  void onInit() {
    httpClient.userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36";
  }

   Future<Response<List<HolidayBean>?>> getHoliday(int year, int month) => get(
        'https://api.haoshenqi.top/holiday?date=$year-$month',
        headers: {"content-type": "application/json;charset=UTF-8",'Access-Control-Allow-Origin': '*'},
        decoder: (data) {
          if (data is List<dynamic>) {
            return data.map((e) => HolidayBean.fromJson(e)).toList();
          }
          return null;
        } ,
      );
}
