import 'package:ble_control_app/actions/actions_set.dart';

abstract class Device {
  String _name;
  ActionsSet _actionsSet;
  
  String get name => _name;
  ActionsSet get actionsSet => _actionsSet;

  Device();
}