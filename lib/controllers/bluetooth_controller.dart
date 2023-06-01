import 'package:get/get.dart';
import '/models/bluetooth/bluetooth_factory.dart';
import '/models/bluetooth/interface_bluetooth.dart';
import '/models/bluetooth/scan_result.dart';

class BluetoothController extends GetxController {
  IBluetooth bluetooth = BluetoothFactory.createBluetooth();

  Future scanDevices() async {
    // Start scanning
    bluetooth.startScan(timeout: const Duration(seconds: 10));
    
    // Listen to scan results
    var subscription = bluetooth.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.deviceIdentifier} found! rssi: ${r.deviceName}');
      }
    });
    print('subscription: $subscription');
    // Stop scanning
    bluetooth.stopScan();
  }

  // scan result stream
  Stream<List<ScanResult>> get scanResults => bluetooth.scanResults;

}