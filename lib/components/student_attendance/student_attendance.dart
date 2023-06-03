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
  final StudentAttendanceController controller =
      Get.put(StudentAttendanceController());

  void updateState() {
    setState(() {});
  }

  Widget getButton() {
    if (controller.scanning) {
      return IconButton(
        onPressed: () {
          controller.stopScan();
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        icon: Icon(
          Icons.stop_sharp,
          color: Colors.white,
        ),
      );
    }

    return IconButton(
      onPressed: () {
        controller.startScan();
        setState(() {});
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      icon: Icon(
        Icons.play_arrow_sharp,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppbarBackground(
        title: "Điểm danh",
        child: FutureBuilder(
            future: controller.initController(updateState),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.tieuDe,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        controller.thongTinDiemDanh,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 5 * 3),
                      Row(
                        children: [
                          getButton(),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () async {
                              bool scanning = controller.scanning;
                              await controller.stopScan();
                              await controller.reload(updateState);
                              if (scanning) controller.startScan();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            icon: Icon(
                              Icons.refresh_sharp,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: controller.scanning
                                ? null
                                : controller.dongBoDuLieuDiemDanh,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
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
                      controller.scanning
                          ? const LinearProgressIndicator()
                          : const SizedBox(
                              width: 8,
                            ),
                      Text(
                        'Danh sách điểm danh',
                        style: TextStyle(fontSize: 18),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.danhSachCoMat.length,
                        itemBuilder: (context, index) {
                          return StudentAttendanceItem(
                              onPressed: updateState,
                              diemDanh:
                                  controller.danhSachCoMat.elementAt(index),
                              index: index);
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.danhSachVang.length,
                        itemBuilder: (context, index) {
                          return StudentAttendanceItem(
                              onPressed: updateState,
                              diemDanh:
                                  controller.danhSachVang.elementAt(index),
                              index: index);
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.danhSachChuaXacDinh.length,
                        itemBuilder: (context, index) {
                          return StudentAttendanceItem(
                              onPressed: updateState,
                              diemDanh:
                                  controller.danhSachChuaXacDinh.elementAt(index),
                              index: index);
                        },
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              return Container(
                  margin: const EdgeInsets.all(8),
                  alignment: FractionalOffset.center,
                  child: const CircularProgressIndicator());
            }));
  }
}
