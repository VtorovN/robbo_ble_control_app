import 'package:ble_control_app/model/action.dart';
import 'package:ble_control_app/bluetooth/ble_api.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class Otto {
  DiscoveredService _service;

  final String _serviceUUID = "fe16f2b0-7783-11eb-9881-0800200c9a66";

  final String _blinkRedUUID = "69869f60-7788-11eb-9881-0800200c9a66";
  final String _blinkGreenUUID = "baa67b3a-b32a-11eb-8529-0242ac130003";
  final String _blinkBlueUUID = "788b23f8-b3e4-11eb-8529-0242ac130003";
  final String _rotateServoUUID = "c6e083e4-b3db-11eb-8529-0242ac130003";

  Map<String, QualifiedCharacteristic> savedCharacteristics;

  BaseAction action() => BaseAction(
      "Action",
      Icon(Icons.create),
      () {}
  );

  BaseAction move() => BaseAction(
      "Move",
      Icon(Icons.accessibility),
      () {}
  );

  BaseAction sound () => BaseAction(
      "Sound",
      Icon(Icons.audiotrack),
      () {}
  );

  BaseAction blink () => BaseAction(
      "Blink",
      Icon(Icons.lightbulb),
      () {}
  );

  Otto() {
    savedCharacteristics = {
      _blinkRedUUID : null,
      _blinkGreenUUID : null,
      _blinkBlueUUID : null,
      _rotateServoUUID : null
    };
  }

  Future _initService() async {
    List<DiscoveredService> services = await BLEAPI.instance.getServices();
    _service = services.firstWhere((service) => service.serviceId.toString() == _serviceUUID);
  }

  Future<QualifiedCharacteristic> getCharacteristicByID(String id) async {
    if (_service == null) {
      await _initService();
    }

    if (savedCharacteristics[id] != null) {
      return savedCharacteristics[id];
    }

    Uuid characteristicUuid = Uuid.parse(id);

    if (!_service.characteristicIds.contains(Uuid.parse(id))) {
      return null;
    }

    return savedCharacteristics[id] = QualifiedCharacteristic(
        characteristicId: characteristicUuid,
        serviceId: _service.serviceId,
        deviceId: BLEAPI.instance.connectedDevice.id
    );
  }

  void blinkRed() async {
    QualifiedCharacteristic characteristic = await getCharacteristicByID(_blinkRedUUID);
    BLEAPI.instance.writeCharacteristic(characteristic, [49]);
  }

  void blinkGreen() async {
    QualifiedCharacteristic characteristic = await getCharacteristicByID(_blinkGreenUUID);
    BLEAPI.instance.writeCharacteristic(characteristic, [49]);
  }

  void blinkBlue() async {
    QualifiedCharacteristic characteristic = await getCharacteristicByID(_blinkBlueUUID);
    BLEAPI.instance.writeCharacteristic(characteristic, [49]);
  }

  void rotateServo(int degrees) async {
    String degreesCode = degrees.toString();
    QualifiedCharacteristic characteristic = await getCharacteristicByID(_rotateServoUUID);
    BLEAPI.instance.writeCharacteristic(characteristic, degreesCode.codeUnits);
  }
}