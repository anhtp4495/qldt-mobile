import 'dart:convert';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '/models/hoat_dong.dart';
import '/constants/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceManagerController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _accessToken = "";
  bool loading = false;
  List<HoatDong> danhSachHoatDong = [];

  Future<void> getDanhSachHoatDong() async {
    danhSachHoatDong.clear();
    loading = true;
    final SharedPreferences prefs = await _prefs;
    Object? accessToken = prefs.get("access_token");
    if (accessToken != null) {
      _accessToken = accessToken as String;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken'
    };
    DateTime now = DateTime.now();
    final queryParameters = {
      //'NgayBatDau': '${DateFormat('dd-MM-yyyy').format(now)} 00:00:00',
      'NgayKetThuc':
          '${DateFormat('dd-MM-yyyy').format(now.add(const Duration(days: 7)))} 00:00:00',
    };

    var url = Uri.parse(ApiEndpoints.instance.activityEndpoint)
        .replace(queryParameters: queryParameters);
    print(url);
    try {
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<dynamic> elements = json["danh_sach_hoat_dong"];
        danhSachHoatDong = elements
            .map<HoatDong>((element) => HoatDong(
                element["Id"],
                element["MaHoatDong"],
                element["TieuDe"],
                element["NoiDung"],
                element["NguoiTao"],
                element["Khoa"],
                element["DiaDiem"],
                element["ThoiGianBatDau"],
                element["ThoiGianKetThuc"]))
            .toList();
      } else {
        final json = jsonDecode(response.body);
        throw json["error_message"] ?? "Unknown error occurred";
      }
    } catch (err) {
      print('ERROR: ${err.toString()}');
    }
    loading = true;
  }
}
