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
  bool _initialized = false;
  bool scanning = false;
  List<SinhVien> _danhSachSinhVien = [];
  List<DiemDanh> _danhSachDiemDanh = [];
  List<String> _danhSachThietBi = [];
  String _maHoatDong = '';
  String _tenBuoiHoatDong = '';

  Future<bool> initController() async {
    if (_initialized) return true;
    _initialized = true;

    final SharedPreferences prefs = await _prefs;
    _maHoatDong = prefs.getString('ma_hoat_dong')!;
    _tenBuoiHoatDong = prefs.getString('ten_buoi_hoat_dong')!;
    _danhSachSinhVien = await _getDanhSachSinhVien();
    _danhSachDiemDanh = _danhSachSinhVien
        .map<DiemDanh>((sv) =>
            DiemDanh(sv.maSinhVien, sv.tenSinhVien, '::::', '', false, null))
        .toList();

    print('initialized');
    return true;
  }

  String _findSinhVien(ScanResult result) {
    int index = _danhSachSinhVien.indexWhere((ele) =>
        ele.danhSachThietBi
            .indexWhere((ele) => ele == result.deviceIdentifier) !=
        -1);
    if (index != -1) {
      return _danhSachSinhVien[index].maSinhVien;
    } else {
      index = _danhSachSinhVien
          .indexWhere((ele) => ele.maSinhVien == result.deviceName);
    }
    return "";
  }

  bool _updateDiemDanh(maSinhVien, maThietBi) {
    int index =
        _danhSachDiemDanh.indexWhere((ele) => ele.maSinhVien == maSinhVien);
    if (index != -1) {
      _danhSachDiemDanh[index].maThietBi = maThietBi;
      _danhSachDiemDanh[index].coMat = true;
      _danhSachDiemDanh[index].thoiGian = DateTime.now();
      return true;
    }

    return false;
  }

  Future startScan(Function updateState) async {
    scanning = true;
    print('Start scanning!');
    // Start scanning
    try {
      bluetooth.startScan(timeout: const Duration(seconds: 10));

      // Listen to scan results
      bluetooth.scanResults.listen((results) {
        // do something with scan results
        bool shouldUpdated = false;
        for (ScanResult r in results) {
          if (r.deviceName == '') continue;

          int thietBiIndex =
              _danhSachThietBi.indexWhere((ele) => ele == r.deviceIdentifier);
          if (thietBiIndex == -1) {
            shouldUpdated = true;
            _danhSachThietBi.add(r.deviceIdentifier);
            if (!_updateDiemDanh(_findSinhVien(r), r)) {
              _danhSachDiemDanh.add(DiemDanh('...', 'Chưa xác định',
                  r.deviceIdentifier, r.deviceName, false, DateTime.now()));
            }
          }
        }

        if (shouldUpdated) {
          updateState();
        }
      });
    } catch (err) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text("Lỗi".toUpperCase()),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(err.toString())],
            );
          });
    }
  }

  Future stopScan() async {
    scanning = false;
    print('Stop scanning!');
    // Stop scanning
    await bluetooth.stopScan();
  }

  void updateDiemDanh(DiemDanh diemDanh) {
    int index = _danhSachDiemDanh
        .indexWhere((ele) => ele.maSinhVien == diemDanh.maSinhVien);
    if (index > -1) {
      _danhSachDiemDanh[index] = diemDanh;
    }
  }

  Future<List<SinhVien>> _getDanhSachSinhVien() async {
    List<SinhVien> danhSachSinhVien = [];
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

    List<SinhVien> danhSachSinhVien = _danhSachDiemDanh
        .where((dd) => dd.coMat && dd.maSinhVien != '...')
        .map<SinhVien>(
            (dd) => SinhVien(dd.maSinhVien, dd.tenSinhVien, [dd.maThietBi]))
        .toList();

    final body = {
      'Id': maBuoiHoatDong.toString(),
      'DanhSachSinhVien': danhSachSinhVien.toString(),
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

  bool get isLoaded => _initialized;
  String get tieuDe => '$_maHoatDong $_tenBuoiHoatDong';

  int get _siso => _danhSachSinhVien.length;
  int get _comat =>
      _danhSachDiemDanh.where((diemdanh) => diemdanh.coMat).length;
  int get _vang => _siso > _comat ? _siso - _comat : 0;
  String get thongTinDiemDanh =>
      'Sỉ số: $_siso, Có mặt: $_comat, Vắng: $_vang';

  List<DiemDanh> get danhSachDiemDanh => _danhSachDiemDanh;
}
