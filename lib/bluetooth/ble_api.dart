import 'dart:async';

import 'package:ble_control_app/bluetooth/scanner.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BLEAPI {
  static final BLEAPI instance = new BLEAPI();
  static final FlutterReactiveBle _ble = FlutterReactiveBle();
  static final _deviceConnectionController =
      StreamController<ConnectionStateUpdate>.broadcast();
  static final BleScanner _bleScanner = BleScanner(_ble);
  static DiscoveredDevice _connectedDevice;
  static StreamSubscription<ConnectionStateUpdate> _deviceConnection;

  Future<void> startScan(int seconds) async {
    _bleScanner.startScan();
    return Future.delayed(Duration(seconds: seconds), () async {
      await stopScan();
    });
  }

  Future<void> stopScan() async {
    return _bleScanner.stopScan();
  }

  Future<bool> connect(DiscoveredDevice device) async {
    if (_connectedDevice != null) {
      await disconnect();
    }

    var completer = Completer<bool>();

    var stream = _ble.connectToDevice(
      id: device.id,
      connectionTimeout: Duration(seconds: 2),
    );

    _deviceConnection = stream.listen((event) {
      _deviceConnectionController.add(event);

      if (event.connectionState == DeviceConnectionState.connected) {
        _connectedDevice = device;
        completer.complete(true);
      }
    });

    return completer.future;
  }

  Future<void> disconnect() async {
    try {
      await _deviceConnection.cancel();
    } on Exception catch (e, _) {
      print('Disconnect failed');
      print(e);
      print(_);
    } finally {
      // Since [_connection] subscription is terminated, the "disconnected" state cannot be received and propagated
      _deviceConnectionController.add(
        ConnectionStateUpdate(
          deviceId: _connectedDevice.id,
          connectionState: DeviceConnectionState.disconnected,
          failure: null,
        ),
      );
      _connectedDevice = null;
    }
  }

  Future<bool> isConnected() async {
    return _connectedDevice != null;
  }

  Future<List<DiscoveredService>> getServices() async {
    if (_connectedDevice != null) {
      return _ble.discoverServices(_connectedDevice.id);
    } else
      return null;
  }

  DiscoveredDevice get connectedDevice => _connectedDevice;

  Stream<BleStatus> getBluetoothState() {
    return _ble.statusStream;
  }

  void writeCharacteristic(
      QualifiedCharacteristic characteristic, List<int> value) {
    _ble.writeCharacteristicWithoutResponse(characteristic, value: value);
  }

  Stream<BleScannerState> getScannerState() {
    return _bleScanner.state;
  }
}
