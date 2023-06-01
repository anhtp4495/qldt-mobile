import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/components/student_attendance/student_attendance.dart';
import '/controllers/attendance_detail_controller.dart';
import '/components/background.dart';
import '/models/hoat_dong.dart';
import '/models/buoi_diem_danh.dart';

class _AttendanceDetailItem extends StatelessWidget {
  final String maHoatDong;
  final BuoiDiemDanh buoiDiemDanh;
  const _AttendanceDetailItem({Key? key, required this.buoiDiemDanh, required this.maHoatDong})
      : super(key: key);

  handlePressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ma_hoat_dong', maHoatDong);
    prefs.setInt('ma_buoi_hoat_dong', buoiDiemDanh.maBuoi);
    prefs.setString('ten_buoi_hoat_dong', buoiDiemDanh.tenBuoi);
    Get.to(const StudentAttendance());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      color: Colors.white,
      child: ListTile(
          title: Text(buoiDiemDanh.tenBuoi),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Ngày: ${buoiDiemDanh.thoiGianBatDau}'),
                Text('Sỉ số: ${buoiDiemDanh.siSo}'),
              ]),
          trailing: FloatingActionButton.extended(
            heroTag: '${buoiDiemDanh.maBuoi}',
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

class AttendanceDetail extends StatefulWidget {
  final HoatDong hoatDong;
  const AttendanceDetail({Key? key, required this.hoatDong}) : super(key: key);

  @override
  State<AttendanceDetail> createState() => _AttendanceDetailState();
}

class _AttendanceDetailState extends State<AttendanceDetail> {
  final AttendanceDetailController attendanceDetailController =
      Get.put(AttendanceDetailController());

  @override
  Widget build(BuildContext context) {
    return AppbarBackground(
        title: widget.hoatDong.maHoatDong,
        child: Container(
          margin: const EdgeInsets.all(8),
          color: Colors.white,
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.hoatDong.tieuDe,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Nội dung: ${widget.hoatDong.noiDung}'),
            Text('Địa điểm: ${widget.hoatDong.diaDiem}'),
            Text('Khoa: ${widget.hoatDong.khoa}'),
            Text('Người tạo: ${widget.hoatDong.nguoiTao}'),
            const SizedBox(height: 24),
            const Text(
              "Danh sách buổi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: FutureBuilder(
              future: attendanceDetailController
                  .getDanhSachHoatDong(widget.hoatDong.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return _AttendanceDetailItem(
                        maHoatDong: widget.hoatDong.maHoatDong,
                        buoiDiemDanh: snapshot.data![index],
                      );
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
            )),
          ]),
        ));
  }
}
