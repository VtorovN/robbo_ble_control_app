import 'package:flutter_blue/flutter_blue.dart';
import 'package:ble_control_app/bluetooth/ble_api.dart';

class Otto {
  BluetoothService _service;

  final String _serviceUUID = "fe16f2b0-7783-11eb-9881-0800200c9a66";
  final String _blinkUUID = "69869f60-7788-11eb-9881-0800200c9a66";

  Map<String, BluetoothCharacteristic> savedCharacteristics;

  Otto() {
    savedCharacteristics = { _blinkUUID : null };
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

  void blink() async {
    BluetoothCharacteristic characteristic = await getCharacteristicByID(_blinkUUID);
    characteristic.write([49]);
  }
}