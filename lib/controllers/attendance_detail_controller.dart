import 'dart:convert';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '/models/buoi_diem_danh.dart';
import '/constants/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceDetailController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _accessToken = "";
  bool loading = false;

  Future<List<BuoiDiemDanh>> getDanhSachHoatDong(int maHoatDong) async {
    List<BuoiDiemDanh> danhSachBuoiDiemDanh = [];
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
      'MaHoatDong': maHoatDong.toString(),
      'ThoiGianBatDau': '${DateFormat('dd-MM-yyyy').format(now)} 00:00:00',
    };

    var url = Uri.parse(ApiEndpoints.instance.activitySessionEndpoint)
        .replace(queryParameters: queryParameters);
    print('URL: $url');
    try {
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<dynamic> elements = json["danh_sach_buoi"];
        danhSachBuoiDiemDanh = elements
            .map<BuoiDiemDanh>((element) => BuoiDiemDanh(
                element["MaHoatDong"],
                element["MaBuoi"],
                element["LoaiBuoi"],
                element["SiSo"],
                element["TenBuoi"],
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
    return danhSachBuoiDiemDanh;
  }
}
