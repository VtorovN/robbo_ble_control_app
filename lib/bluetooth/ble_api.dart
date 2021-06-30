import 'package:flutter_blue/flutter_blue.dart';

class BLEAPI {
  static BLEAPI instance = new BLEAPI();
  static BluetoothDevice _connectedDevice;
  static FlutterBlue _fb = FlutterBlue.instance;

  Future<void> startScan() async {
    if (!(await _fb.isScanning.isEmpty) && await _fb.isScanning.first == false) {
      return _fb.startScan(timeout: Duration(seconds: 5));
    }
  }

  Future<void> stopScan() async {
    return _fb.stopScan();
  }

  Stream<List<ScanResult>> getScanResults() {
    return _fb.scanResults;
  }

  Future<bool> connect(BluetoothDevice device) async {
    if (_connectedDevice != null) {
      await disconnect();
    }

    await device.connect(autoConnect: false);

    List<BluetoothDevice> connectedDevices = await _fb.connectedDevices;

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

  Future<bool> isConnected() async {
    if(await _connectedDevice.state.first == BluetoothDeviceState.connected) {
      return true;
    }
    else {
      _connectedDevice = null;
      return false;
    }
  }

  Future<List<BluetoothService>> getServices() async {
    if (_connectedDevice != null) {
      return _connectedDevice.discoverServices();
    }
    else return null;
  }

  Stream<bool> isScanningStream() {
    return _fb.isScanning;
  }

  BluetoothDevice get connectedDevice => _connectedDevice;

  Stream<BluetoothState> getBluetoothState() {
    return _fb.state;
  }
}
