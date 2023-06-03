import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import '/models/diem_danh.dart';
import '/controllers/student_attendance_controller.dart';

class DropdownButtonExample extends StatefulWidget {
  final Iterable<DiemDanh> listItems;
  final TextEditingController? maSinhVienController;
  const DropdownButtonExample(
      {super.key, required this.listItems, this.maSinhVienController});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.maSinhVienController!.text == ''
          ? null
          : widget.maSinhVienController!.text.trim(),
      disabledHint: Text('Chọn sinh viên'),
      icon: const Icon(Icons.arrow_downward),
      isExpanded: true,
      isDense: true,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          widget.maSinhVienController!.text = value!;
        });
      },
      items:
          widget.listItems.map<DropdownMenuItem<String>>((DiemDanh diemDanh) {
        return DropdownMenuItem<String>(
          value: diemDanh.maSinhVien.trim(),
          child: Text('${diemDanh.maSinhVien} - ${diemDanh.tenSinhVien}'),
        );
      }).toList(),
    );
  }
}

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
    final StudentAttendanceController controller =
        Get.find<StudentAttendanceController>();
    controller.updateDiemDanh(maSinhVienController.text.trim(), widget.diemDanh.maThietBi);
    Navigator.of(context).pop();
  }

  void handlePressed() {
    if (widget.diemDanh.maSinhVien == '...') {
      final StudentAttendanceController controller =
          Get.find<StudentAttendanceController>();

      Iterable<DiemDanh> listItems = controller.danhSachVang;

      if (listItems.length > 0) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Sinh viên'),
                content: DropdownButtonExample(
                    listItems: listItems,
                    maSinhVienController: maSinhVienController),
                actions: <Widget>[
                  TextButton(
                    onPressed: updateFromMSSV,
                    child: const Text('Đồng ý'),
                  ),
                  TextButton(
                    child: const Text('Huỷ'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
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
