import '/models/bluetooth/android_bluetooth.dart';
import '/models/bluetooth/interface_bluetooth.dart';
import 'package:get/get.dart';

class BluetoothFactory {
  static IBluetooth createBluetooth() {
    IBluetooth? bluetooth;
    if (GetPlatform.isWeb) {
    } else if (GetPlatform.isAndroid) {
      bluetooth = AndroidBluetooth.instance;
    } else if (GetPlatform.isIOS) {
      bluetooth = AndroidBluetooth.instance;
    } else if (GetPlatform.isMobile) {
      bluetooth = AndroidBluetooth.instance;
    }

    if (bluetooth == null) {
      throw UnimplementedError("Not implemented!");
    }
    return bluetooth;
  }
}
