import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hufi/components/attendance_manager/attendance_detail.dart';
import '/models/hoat_dong.dart';

class AttendanceItem extends StatelessWidget {
  final int index;
  final HoatDong hoatDong;
  const AttendanceItem({Key? key, required this.hoatDong, required this.index})
      : super(key: key);

  handleTap() {
    Get.to(AttendanceDetail(hoatDong: hoatDong));
  }

  Color? getColor() {
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      color: Colors.white,
      child: ListTile(
        title: Text('${hoatDong.maHoatDong} - ${hoatDong.tieuDe}'),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Địa điểm: ${hoatDong.diaDiem}'),
              Text(
                  'Thời gian: ${hoatDong.thoiGianBatDau} - ${hoatDong.thoiGianKetThuc}'),
            ]),
        trailing: const Icon(Icons.forward_outlined),
        onTap: handleTap,
      ),
    );
  }
}
