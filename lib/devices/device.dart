import 'package:ble_control_app/model/base_action.dart';
import 'package:flutter/material.dart';

class Device {
  String name = "Device";
  List<Function> _actions = <Function>[];
  List<Function> get actions => _actions;

  Device() {
    _actions.add(button);
    _actions.add(sound);
    _actions.add(blink);
    _actions.add(move);
    _actions.add(turnLeft);
    _actions.add(turnRight);
  }

  BaseAction button() => BaseAction(
      "Button",
      Icon(Icons.create),
      () {}
  );

  BaseAction move() => BaseAction(
      "Move",
      Icon(Icons.accessibility),
      () {}
  );

  BaseAction sound () => BaseAction(
      "Sound",
      Icon(Icons.audiotrack),
      () {}
  );

  BaseAction blink () => BaseAction(
      "Blink",
      Icon(Icons.lightbulb),
      () {}
  );

  BaseAction turnLeft() => BaseAction(
      "Turn Left",
      Icon(Icons.arrow_left),
      () {}
  );

  BaseAction turnRight() => BaseAction(
      "Turn Right",
      Icon(Icons.arrow_right),
      () {}
  );
}