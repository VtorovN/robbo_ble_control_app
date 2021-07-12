import 'package:ble_control_app/devices/device.dart';

import 'actions_set.dart';

class Sets { // Тут просто список наборов
  Map<String, ActionsSet> _sets =  Map<String, ActionsSet>();

  Sets.device(List<Device> devices) {  
    for (var device in devices) {
      _sets.addAll({device.name : device.actionsSet});
    }
  }

  Map<String, ActionsSet> get get => _sets;
  ActionsSet getSet(String name) => _sets[name];

  void add(String name, ActionsSet actionsSet) { //TODO: Сохранять между запусками программы
    _sets.addAll({name : actionsSet});
  }
}