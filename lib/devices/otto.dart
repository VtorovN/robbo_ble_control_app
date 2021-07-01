import 'package:ble_control_app/devices/device.dart';
import 'package:ble_control_app/bluetooth/ble_api.dart';

import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

class Otto extends Device {
  BluetoothService _service;

  final String _serviceUUID = "fe16f2b0-7783-11eb-9881-0800200c9a66";

  final String _blinkRedUUID = "69869f60-7788-11eb-9881-0800200c9a66";
  final String _blinkGreenUUID = "baa67b3a-b32a-11eb-8529-0242ac130003";
  final String _blinkBlueUUID = "788b23f8-b3e4-11eb-8529-0242ac130003";
  final String _rotateServoUUID = "c6e083e4-b3db-11eb-8529-0242ac130003";

  Map<String, BluetoothCharacteristic> savedCharacteristics;

  @override
  String name = "Otto";
  String get getName => name;

  @override
  List<Function> _actions = <Function>[];
  List<Function> get actions => _actions;

  Otto() {
    savedCharacteristics = {
      _blinkRedUUID : null,
      _blinkGreenUUID : null,
      _blinkBlueUUID : null,
      _rotateServoUUID : null
    };

    _actions.add(super.button);
    _actions.add(super.sound);
    _actions.add(super.blink);
    _actions.add(super.move);
  }

  Future _initService() async {
    List<BluetoothService> services = await BLEAPI.instance.getServices();
    _service = services.firstWhere((service) => service.uuid.toString() == _serviceUUID);
  }

  Future<BluetoothCharacteristic> getCharacteristicByID(String id) async {
    if (_service == null) {
      await _initService();
    }

    if (savedCharacteristics[id] != null) {
      return savedCharacteristics[id];
    }

    return savedCharacteristics[id] =
        _service.characteristics.firstWhere((characteristic) => characteristic.uuid.toString() == id);
  }

  void blinkRed() async {
    BluetoothCharacteristic characteristic = await getCharacteristicByID(_blinkRedUUID);
    characteristic.write([49]);
  }

  void blinkGreen() async {
    BluetoothCharacteristic characteristic = await getCharacteristicByID(_blinkGreenUUID);
    characteristic.write([49]);
  }

  void blinkBlue() async {
    BluetoothCharacteristic characteristic = await getCharacteristicByID(_blinkBlueUUID);
    characteristic.write([49]);
  }

  void rotateServo(int degrees) async {
    String degreesCode = degrees.toString();
    BluetoothCharacteristic characteristic = await getCharacteristicByID(_rotateServoUUID);
    characteristic.write(degreesCode.codeUnits);
  }
}