import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hufi/components/attendance_manager/attendance_item.dart';
import 'package:hufi/controllers/attendance_manager_controller.dart';

import '/components/background.dart';

class AttendanceManagerList extends StatefulWidget {
  const AttendanceManagerList({Key? key}) : super(key: key);

  @override
  State<AttendanceManagerList> createState() => _AttendanceManagerListState();
}

class _AttendanceManagerListState extends State<AttendanceManagerList> {
  final AttendanceManagerController attendanceManagerController =
      Get.put(AttendanceManagerController());

  @override
  Widget build(BuildContext context) {
    return AppbarBackground(
        title: "Danh sách hoạt động",
        child: FutureBuilder(
          future: attendanceManagerController.getDanhSachHoatDong(),
          builder: (context, snapshot) {
            if (attendanceManagerController.loading) {
              return ListView.builder(
                itemCount: attendanceManagerController.danhSachHoatDong.length,
                itemBuilder: (context, index) {
                  return AttendanceItem(
                      index: index,
                      hoatDong:
                          attendanceManagerController.danhSachHoatDong[index]);
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            // By default show a loading spinner.
            return Container(
                margin: const EdgeInsets.all(8),
                alignment: FractionalOffset.center,
                child: const CircularProgressIndicator());
          },
        ));
  }
}
