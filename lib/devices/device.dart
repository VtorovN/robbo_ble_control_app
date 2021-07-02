import 'package:ble_control_app/model/Sets.dart';
import 'package:ble_control_app/model/actions_set.dart';
import 'package:ble_control_app/model/base_action.dart';
import 'package:ble_control_app/screens/home/home_page.dart';
import 'package:flutter/material.dart';

abstract class Device {
  String _name;
  ActionsSet _actionsSet;
  
  String get name => _name;
  ActionsSet get actionsSet => _actionsSet;
}