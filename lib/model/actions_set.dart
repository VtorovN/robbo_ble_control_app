import 'package:ble_control_app/actions/base_action.dart';
import 'package:flutter/material.dart';

class ActionsSet {
  String _name;
  List<Function> _actions = <Function>[];

  ActionsSet(this._name);

  String get name => _name;
  List<Function> get actions => _actions;

  static BaseAction button() => BaseAction(
      "Button",
      Icon(Icons.create),
      () {},
      false,
      1
  );

  static BaseAction blink() => BaseAction(
      "Blink",
      Icon(Icons.lightbulb),
      () {},
      false,
      1
  );

  static BaseAction move() => BaseAction(
      "Move",
      Icon(Icons.accessibility),
      () {},
      false,
      1
  );

  static BaseAction sound () => BaseAction(
      "Sound",
      Icon(Icons.audiotrack),
      () {},
      false,
      1
  );

  static BaseAction turnLeft() => BaseAction(
      "Turn Left",
      Icon(Icons.arrow_left),
      () {},
      false,
      1
  );

  static BaseAction turnRight() => BaseAction(
      "Turn Right",
      Icon(Icons.arrow_right),
      () {},
      false,
      1
  );
}