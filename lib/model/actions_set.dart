import 'package:ble_control_app/model/base_action.dart';
import 'package:flutter/material.dart';

class ActionsSet {
  List<Function> _actions = <Function>[];
  List<Function> get actions => _actions;

  static BaseAction button() => BaseAction(
      "Button",
      Icon(Icons.create),
      () {}
  );

  static BaseAction blink() => BaseAction(
      "Blink",
      Icon(Icons.lightbulb),
      () {}
  );

  static BaseAction move() => BaseAction(
      "Move",
      Icon(Icons.accessibility),
      () {}
  );

  static BaseAction sound () => BaseAction(
      "Sound",
      Icon(Icons.audiotrack),
      () {}
  );

  static BaseAction turnLeft() => BaseAction(
      "Turn Left",
      Icon(Icons.arrow_left),
      () {}
  );

  static BaseAction turnRight() => BaseAction(
      "Turn Right",
      Icon(Icons.arrow_right),
      () {}
  );
}