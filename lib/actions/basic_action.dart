import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicAction {
  String _title;
  Icon _icon;
  Function _onPressed;
  bool _mode; // High-Low
  double _pin;

  BasicAction(this._title, this._icon, this._onPressed, this._mode, this._pin);

  BasicAction.clone(BasicAction original)
    : this(original.title, original.icon, original.onPressed, original.mode, original.pin);

  void matchTo(BasicAction action) {
    _title = action.title;
    _icon = action.icon;
    _onPressed = action.onPressed;
    _mode = action.mode;
    _pin = action.pin;
  }

  void changeMode() {
    _mode = !_mode;
  }

  Function get onPressed => _onPressed;
  set onPressed(Function value) => _onPressed = value;

  double get pin => _pin;
  set pin(value) => _pin = value;

  String get title => _title;
  set title(value) => _title = value;

  Icon get icon => _icon;
  set icon(value) => _icon = value;

  bool get mode => _mode;
  set mode(value) => _mode = value;
}
