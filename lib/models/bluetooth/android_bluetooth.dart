import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '/models/bluetooth/interface_bluetooth.dart';
// ignore: library_prefixes
import '/models/bluetooth/scan_result.dart' as hufiModel;

class AndroidBluetooth implements IBluetooth {
  AndroidBluetooth._privateConstructor();
  static final AndroidBluetooth _instance = AndroidBluetooth._privateConstructor();
  static AndroidBluetooth get instance => _instance;

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  @override
  Stream<List<hufiModel.ScanResult>> get scanResults =>
      flutterBlue.scanResults.map<List<hufiModel.ScanResult>>((list) => list
          .map<hufiModel.ScanResult>((scanResult) => hufiModel.ScanResult(
              scanResult.device.id.id, scanResult.device.name))
          .toList());

  @override
  Future startScan({ Duration? timeout }) async {
    return await flutterBlue.startScan(
        timeout: timeout, allowDuplicates: false);
  }

  @override
  Future stopScan() async {
    return await flutterBlue.stopScan();
  }
}
