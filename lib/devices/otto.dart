import 'package:flutter_blue/flutter_blue.dart';
import 'package:ble_control_app/bluetooth/ble_api.dart';

class Otto {
  BluetoothService _service;

  final String _serviceUUID = "fe16f2b0-7783-11eb-9881-0800200c9a66";
  final String _blinkRedUUID = "69869f60-7788-11eb-9881-0800200c9a66";
  final String _blinkGreenUUID = "baa67b3a-b32a-11eb-8529-0242ac130003";

  Map<String, BluetoothCharacteristic> savedCharacteristics;

  Otto() {
    savedCharacteristics = { _blinkRedUUID : null, _blinkGreenUUID : null};
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
}