import '../bluetooth/ble_api.dart';

class Command {
  String _commandName;
  String _commandID;

  Command(this._commandName, this._commandID);

  void run() {
    // TODO: BLE runs command by name or ID
  }
}