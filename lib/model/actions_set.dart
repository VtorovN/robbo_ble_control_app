import 'package:ble_control_app/actions/basic_action.dart';
import 'package:flutter/material.dart';

class ActionsSet { // Реализация Одного набора
  String _name;
  List<Function> _actions = <Function>[];

  ActionsSet(this._name);

  String get name => _name;
  List<Function> get actions => _actions;

  static BasicAction button() => BasicAction(
      "Button",
      Icon(Icons.create),
      () {},
      false,
      1
  );

  static BasicAction blink() => BasicAction(
      "Blink",
      Icon(Icons.lightbulb),
      () {},
      false,
      1
  );

  static BasicAction move() => BasicAction(
      "Move",
      Icon(Icons.accessibility),
      () {},
      false,
      1
  );

  static BasicAction sound () => BasicAction(
      "Sound",
      Icon(Icons.audiotrack),
      () {},
      false,
      1
  );

  static BasicAction turnLeft() => BasicAction(
      "Turn Left",
      Icon(Icons.arrow_left),
      () {},
      false,
      1
  );

  static BasicAction turnRight() => BasicAction(
      "Turn Right",
      Icon(Icons.arrow_right),
      () {},
      false,
      1
  );
}