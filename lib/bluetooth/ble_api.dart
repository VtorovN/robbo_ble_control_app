import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BLEAPI {
  static BLEAPI instance = new BLEAPI();
  static BluetoothDevice _connectedDevice;

  Future<void> startScan() {
    return FlutterBlue.instance.startScan(timeout: Duration(seconds: 5));
  }

  Stream<List<ScanResult>> getScanResults() {
    return FlutterBlue.instance.scanResults;
  }

  Future<bool> connect(BluetoothDevice device) async {
    if (_connectedDevice != null) {
      await disconnect();
    }

    await device.connect();

    List<BluetoothDevice> connectedDevices = await FlutterBlue.instance.connectedDevices;
    if(connectedDevices.contains(device)) {
      _connectedDevice = device;
      return true;
    }
    else return false;
  }

  Future<void> disconnect() async {
    await _connectedDevice.disconnect();
    _connectedDevice = null;
  }

  Future<List<BluetoothService>> getServices() async {
    if (_connectedDevice != null) {
      return _connectedDevice.discoverServices();
    }
    else return null;
  }
}
