import 'dart:async';
import 'package:ble_control_app/bluetooth/reactive_state.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:meta/meta.dart';

class BleScanner implements ReactiveState<BleScannerState> {
  StreamSubscription _subscription;

  final FlutterReactiveBle _ble;
  final StreamController<BleScannerState> _stateStreamController = StreamController<BleScannerState>.broadcast();
  final _devices = <DiscoveredDevice>[];

  BleScanner(this._ble);

  @override
  Stream<BleScannerState> get state => _stateStreamController.stream;

  void startScan() {
    _devices.clear();
    _subscription?.cancel();
    _subscription =
        _ble.scanForDevices(withServices: []).listen((device) {
          final knownDeviceIndex = _devices.indexWhere((d) => d.id == device.id);
          if (knownDeviceIndex >= 0) {
            _devices[knownDeviceIndex] = device;
          } else {
            _devices.add(device);
          }
          _pushState();
        });
    _pushState();
  }

  void _pushState() {
    _stateStreamController.add(
      BleScannerState(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
      ),
    );
  }

  Future<void> stopScan() async {
    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

  Future<void> dispose() async {
    await _stateStreamController.close();
  }
}

@immutable
class BleScannerState {
  const BleScannerState({
    this.discoveredDevices,
    this.scanIsInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool scanIsInProgress;
}