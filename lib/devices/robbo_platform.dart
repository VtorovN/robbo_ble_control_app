import 'package:ble_control_app/devices/device.dart';

class RobboPlatform extends Device {
  @override
  String name = "Robbo Platform"; 
  String get getName => name;

  @override
  List<Function> _actions = <Function>[];
  List<Function> get actions => _actions;

  RobboPlatform() {
    _actions.add(super.turnLeft);
    _actions.add(super.turnRight);
    _actions.add(super.move);
  }
}