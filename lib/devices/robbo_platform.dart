import 'package:ble_control_app/devices/device.dart';
import 'package:ble_control_app/actions/actions_set.dart';

class RobboPlatform extends Device {
  String _name = "Robbo Platform";
  String get name => _name;

  ActionsSet _actionsSet = ActionsSet("Robbo Platform"); //TODO: Создать Уникальный набор для RobboPlatform
  ActionsSet get actionsSet => _actionsSet;

  RobboPlatform() {
    _actionsSet.actions.add(ActionsSet.button);
    _actionsSet.actions.add(ActionsSet.move);
    _actionsSet.actions.add(ActionsSet.turnRight);
    _actionsSet.actions.add(ActionsSet.turnLeft);
  }
}