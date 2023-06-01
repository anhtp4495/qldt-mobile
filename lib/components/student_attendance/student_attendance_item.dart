import 'package:flutter/material.dart';
import '/models/diem_danh.dart';

class StudentAttendanceItem extends StatelessWidget {
  final int index;
  final DiemDanh diemDanh;
  final Function? onPressed;
  const StudentAttendanceItem(
      {Key? key,
      required this.diemDanh,
      required this.index,
      required this.onPressed})
      : super(key: key);

  Color? getColor() {
    return Colors.greenAccent;
  }

  Icon getLeadingIcon() {
    if (diemDanh.coMat) {
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
    if (diemDanh.coMat) {
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

  void handlePressed() {
    diemDanh.coMat = !diemDanh.coMat;
    onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      color: Colors.white,
      child: ListTile(
          leading: getLeadingIcon(),
          title: Text(diemDanh.tenSinhVien),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(diemDanh.maSinhVien),
                Text(diemDanh.maThietBi),
              ]),
          trailing: IconButton(
            onPressed: handlePressed,
            icon: getTrailingIcon(),
          )),
    );
  }
}
