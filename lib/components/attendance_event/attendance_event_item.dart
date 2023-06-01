import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/components/student_attendance/student_attendance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/buoi_diem_danh.dart';

class AttendanceEventItem extends StatelessWidget {
  final int index;
  final BuoiDiemDanh buoiDiemDanh;
  const AttendanceEventItem(
      {Key? key, required this.buoiDiemDanh, required this.index})
      : super(key: key);

  handlePressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('ma_buoi_hoat_dong', buoiDiemDanh.maBuoi);
    prefs.setString('ten_buoi_hoat_dong', buoiDiemDanh.tenBuoi);
    Get.to(const StudentAttendance());
  }

  Color? getColor() {
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      color: Colors.white,
      child: ListTile(
          title: Text(buoiDiemDanh.maHoatDong),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    '${buoiDiemDanh.tenBuoi} ngày ${buoiDiemDanh.thoiGianBatDau}'),
                Text('Sỉ số: ${buoiDiemDanh.siSo}'),
              ]),
          trailing: FloatingActionButton.extended(
            heroTag: '${buoiDiemDanh.maBuoi}.$index',
            extendedPadding: const EdgeInsets.fromLTRB(2, 0, 4, 0),
            backgroundColor: Colors.white,
            onPressed: handlePressed,
            icon: const Icon(
              Icons.play_arrow,
              color: Colors.blueAccent,
              size: 24.0,
            ),
            label: const Text(
              'Điểm danh',
              style: TextStyle(color: Colors.blueAccent),
            ),
          )),
    );
  }
}
