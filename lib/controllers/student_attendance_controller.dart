import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/models/diem_danh.dart';
import '/models/sinh_vien.dart';
import '/constants/api_endpoints.dart';
import '/models/bluetooth/bluetooth_factory.dart';
import '/models/bluetooth/interface_bluetooth.dart';
import '/models/bluetooth/scan_result.dart';

class StudentAttendanceController extends GetxController {
  final IBluetooth bluetooth = BluetoothFactory.createBluetooth();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool loading = true;
  bool scanning = false;
  List<SinhVien> _danhSachSinhVien = [];
  List<DiemDanh> danhSachDiemDanh = [];
  List<String> danhSachThietBi = [];

  @override
  void onInit() async {
    super.onInit();
    loading = true;
    scanning = false;

    _danhSachSinhVien = await getDanhSachSinhVien();
    danhSachDiemDanh = _danhSachSinhVien
        .map<DiemDanh>((sv) =>
            DiemDanh(sv.maSinhVien, sv.tenSinhVien, '::::', false, null))
        .toList();
    loading = false;
  }

  String _findSinhVien(maThietBi) {
    int index = _danhSachSinhVien.indexWhere((ele) =>
        ele.danhSachThietBi.indexWhere((ele) => ele == maThietBi) != -1);
    if (index != -1) {
      return _danhSachSinhVien[index].maSinhVien;
    }
    return "";
  }

  bool _updateDiemDanh(maSinhVien, maThietBi) {
    int index =
        danhSachDiemDanh.indexWhere((ele) => ele.maSinhVien == maSinhVien);
    if (index != -1) {
      danhSachDiemDanh[index].maThietBi = maThietBi;
      danhSachDiemDanh[index].coMat = true;
      danhSachDiemDanh[index].thoiGian = DateTime.now();
      return true;
    }

    return false;
  }

  Future startScan(Function updateState) async {
    scanning = true;
    print('Start scanning!');
    // Start scanning
    bluetooth.startScan(timeout: const Duration(seconds: 10));

    // Listen to scan results
    bluetooth.scanResults.listen((results) {
      // do something with scan results
      bool shouldUpdated = false;
      for (ScanResult r in results) {
        int thietBiIndex =
            danhSachThietBi.indexWhere((ele) => ele == r.deviceIdentifier);
        if (thietBiIndex == -1) {
          shouldUpdated = true;
          danhSachThietBi.add(r.deviceIdentifier);
          if (!_updateDiemDanh(
              _findSinhVien(r.deviceIdentifier), r.deviceIdentifier)) {
            danhSachDiemDanh.add(DiemDanh('...', 'Chưa xác định',
                r.deviceIdentifier, false, DateTime.now()));
          }
        }
      }

      if (shouldUpdated) {
        updateState();
      }
    });
  }

  Future stopScan() async {
    scanning = false;
    print('Stop scanning!');
    // Stop scanning
    await bluetooth.stopScan();
  }

  void updateDiemDanh(DiemDanh diemDanh) {
    int index = danhSachDiemDanh
        .indexWhere((ele) => ele.maSinhVien == diemDanh.maSinhVien);
    if (index > -1) {
      danhSachDiemDanh[index] = diemDanh;
    }
  }

  Future<List<SinhVien>> getDanhSachSinhVien() async {
    List<SinhVien> danhSachSinhVien = [];
    loading = true;
    final SharedPreferences prefs = await _prefs;
    String? accessToken = prefs.getString("access_token");
    int? maBuoiHoatDong = prefs.getInt("ma_buoi_hoat_dong");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final queryParameters = {
      'MaBuoiHoatDong': maBuoiHoatDong.toString(),
    };

    var url = Uri.parse(ApiEndpoints.instance.studentAttendanceEndpoint)
        .replace(queryParameters: queryParameters);
    print('URL: $url');
    try {
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<dynamic> elements = json["danh_sach_sinh_vien"];
        danhSachSinhVien = elements
            .map<SinhVien>((element) => SinhVien(
                element["MaSinhVien"],
                element["TenSinhVien"],
                (element["DanhSachThietBi"] as List<dynamic>)
                    .map<String>((element) => '$element')
                    .toList()))
            .toList();
      } else {
        final json = jsonDecode(response.body);
        throw json["error_message"] ?? "Unknown error occurred";
      }
    } catch (err) {
      print('ERROR: ${err.toString()}');
    }

    return danhSachSinhVien;
  }

  Future<void> dongBoDuLieuDiemDanh() async {
    final SharedPreferences prefs = await _prefs;
    String? accessToken = prefs.getString("access_token");
    int? maBuoiHoatDong = prefs.getInt("ma_buoi_hoat_dong");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final body = {
      'danhSachDiemDanh': danhSachDiemDanh.toString(),
    };

    var url = Uri.parse(ApiEndpoints.instance.attendanceEndpoint);
    print('URL: $url');
    try {
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print('statusCode: ${response.statusCode}');
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text("Thông báo".toUpperCase()),
              contentPadding: const EdgeInsets.all(20),
              children: const [Text("Đồng bộ thành công!")],
            );
          });
    } catch (err) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text("Lỗi".toUpperCase()),
              contentPadding: const EdgeInsets.all(20),
              children: const [Text("Đồng bộ thất bại!")],
            );
          });
    }
  }

  Future<String> getTenBuoiHoatDong() async {
    final SharedPreferences prefs = await _prefs;
    String? maHoatDong = prefs.getString('ma_hoat_dong');
    String? tenBuoiHoatDong = prefs.getString('ten_buoi_hoat_dong');
    return '$maHoatDong $tenBuoiHoatDong';
  }

  Future<String> getThongTinDiemDanh() async {
    int siso = _danhSachSinhVien.length;
    if (loading) {
      var danhSachSinhVien = await getDanhSachSinhVien();
      siso = danhSachSinhVien.length;
    }
    int comat = danhSachDiemDanh.where((diemdanh) => diemdanh.coMat).length;
    int vang = siso - comat;
    vang = vang > 0 ? vang : 0;

    return 'Sỉ số: $siso, Có mặt: $comat, Vắng: $vang';
  }
}
