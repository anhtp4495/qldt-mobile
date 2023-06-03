import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import '/models/diem_danh.dart';
import '/constants/api_endpoints.dart';

class StudentAttendanceItem extends StatefulWidget {
  final int index;
  final DiemDanh diemDanh;
  final Function? onPressed;
  const StudentAttendanceItem(
      {Key? key,
      required this.diemDanh,
      required this.index,
      required this.onPressed})
      : super(key: key);

  @override
  State<StudentAttendanceItem> createState() => _StudentAttendanceItemState();
}

class _StudentAttendanceItemState extends State<StudentAttendanceItem> {
  TextEditingController maSinhVienController = TextEditingController();

  Color? getColor() {
    return Colors.greenAccent;
  }

  Icon getLeadingIcon() {
    if (widget.diemDanh.coMat) {
      return const Icon(
        Icons.check_circle_rounded,
        color: Colors.greenAccent,
      );
    }

    return const Icon(
      Icons.radio_button_unchecked_outlined,
      color: Colors.redAccent,
    );
  }

  Icon getTrailingIcon() {
    if (widget.diemDanh.coMat) {
      return const Icon(
        Icons.remove,
        color: Colors.blueGrey,
      );
    }

    return const Icon(
      Icons.add,
      color: Colors.blueGrey,
    );
  }

  Future<void> updateFromMSSV() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("access_token");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    Map body = {
      'MaSinhVien': maSinhVienController.text.trim(),
      'TenSinhVien': '',
      'DanhSachThietBi': [widget.diemDanh.maThietBi]
    };

    var url = Uri.parse(ApiEndpoints.instance.studentDeviceEndpoint);
    print('URL: $url');
    try {
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var sv = json["sinh_vien"];
        print('body: $sv');
        setState(() {
          widget.diemDanh.maSinhVien = sv["MaSinhVien"];
          widget.diemDanh.tenSinhVien = sv["TenSinhVien"];
          widget.diemDanh.coMat = true;
        });
      } else {
        final json = jsonDecode(response.body);
        throw json["error_message"] ?? "Unknown error occurred";
      }
    } catch (err) {
      print('ERROR: ${err.toString()}');
    }

    maSinhVienController.clear();
    Navigator.of(context).pop();
  }

  void handlePressed() {
    if (widget.diemDanh.maSinhVien == '...') {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Mã sinh viên'),
              content: TextField(
                  controller: maSinhVienController,
                  decoration: const InputDecoration(
                      hintText: 'Nhập mã sinh viên...')),
              actions: <Widget>[
                TextButton(
                  onPressed: updateFromMSSV,
                  child: const Text('Đồng ý'),
                ),
                TextButton(
                  child: const Text('Huỷ'),
                  onPressed: () {
                    maSinhVienController.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      widget.diemDanh.coMat = !widget.diemDanh.coMat;
    }
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      color: Colors.white,
      child: ListTile(
          leading: getLeadingIcon(),
          title: Text(widget.diemDanh.tenSinhVien),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.diemDanh.maSinhVien),
                Text(
                    '${widget.diemDanh.maThietBi} - ${widget.diemDanh.tenThietBi}'),
              ]),
          trailing: IconButton(
            onPressed: handlePressed,
            icon: getTrailingIcon(),
          )),
    );
  }
}
