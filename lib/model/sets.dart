import 'package:ble_control_app/devices/device.dart';
import 'package:ble_control_app/model/actions_set.dart';
import 'package:ble_control_app/model/base_action.dart';
import 'package:flutter/material.dart';

class Sets {
  Map<String, ActionsSet> _sets =  Map<String, ActionsSet>();

  Sets(List<Device> devices) {  
    for (var device in devices) {
      _sets.addAll({device.name : device.actionsSet});
    }
  }

  Map<String, ActionsSet> get() => _sets;
  ActionsSet getSet(String name) => _sets[name];

  void add(String name, ActionsSet actionsSet) { //TODO: Сохранять между запусками программы
    _sets.addAll({name : actionsSet});
  }
}