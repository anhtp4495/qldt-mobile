import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/student_attendance_controller.dart';
import '/components/background.dart';
import '/components/student_attendance/student_attendance_item.dart';

class StudentAttendance extends StatefulWidget {
  const StudentAttendance({Key? key}) : super(key: key);

  @override
  State<StudentAttendance> createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  final StudentAttendanceController studentAttendanceController =
      Get.put(StudentAttendanceController());

  void updateState() {
    setState(() {});
  }

  ElevatedButton getButton() {
    if (studentAttendanceController.scanning) {
      return ElevatedButton(
        onPressed: () {
          studentAttendanceController.stopScan();
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.stop_sharp,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Dừng điểm danh',
                style: TextStyle(fontSize: 18),
              )
            ]),
      );
    }

    return ElevatedButton(
      onPressed: () {
        studentAttendanceController.startScan(updateState);
        setState(() {});
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      child: Row(children: const [
        Icon(
          Icons.play_arrow_sharp,
          color: Colors.white,
        ),
        SizedBox(width: 8),
        Text(
          'Bắt đầu điểm danh',
          style: TextStyle(fontSize: 18),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppbarBackground(
        title: "Điểm danh",
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: studentAttendanceController.getTenBuoiHoatDong(),
                builder: (context, snapshot) {
                  String str = 'Hoạt Động';
                  if (snapshot.hasData) {
                    str = snapshot.data as String;
                  }
                  return Text(
                    str,
                    style: const TextStyle(fontSize: 18),
                  );
                },
              ),
              FutureBuilder(
                  future: studentAttendanceController.getThongTinDiemDanh(),
                  builder: (context, snapshot) {
                    String str = 'Sỉ số: x, Có mặt: 0, Vắng: x';
                    if (snapshot.hasData) {
                      str = snapshot.data as String;
                    }
                    return Text(
                      str,
                      style: const TextStyle(fontSize: 18),
                    );
                  }),
              const SizedBox(height: 5 * 3),
              Row(
                children: [
                  getButton(),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: studentAttendanceController.dongBoDuLieuDiemDanh,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    child: Row(children: const [
                      Icon(
                        Icons.cloud_upload_sharp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Đồng bộ',
                        style: TextStyle(fontSize: 18),
                      )
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: studentAttendanceController.getDanhSachSinhVien(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          studentAttendanceController.danhSachDiemDanh.length,
                      itemBuilder: (context, index) {
                        return StudentAttendanceItem(
                            onPressed: updateState,
                            diemDanh: studentAttendanceController
                                .danhSachDiemDanh[index],
                            index: index);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  if (studentAttendanceController.loading) {
                    return Container(
                        margin: const EdgeInsets.all(8),
                        alignment: FractionalOffset.center,
                        child: const CircularProgressIndicator());
                  }
                  // By default show a loading spinner.
                  return const Text('Không có dữ liệu');
                },
              ),
            ],
          ),
        ));
  }
}
