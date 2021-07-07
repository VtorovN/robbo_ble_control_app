import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseAction {
  String _title;
  Icon _icon;
  Function _onPressed;
  bool _mode; // High-Low
  double _pin;
  
  BaseAction(this._title, this._icon, this._onPressed) {
    _mode = false;
    _pin = 1;
  }

  BaseAction.clone(BaseAction original): this(original.title, original.icon, original.onPressed);

  void changeMode() {
    _mode = !_mode;
  }

  Function get onPressed => _onPressed;
  set onPressed(Function value) => this._onPressed = value;

  double get pin => this._pin;
  set pin(value) => this._pin = value;

  get title => this._title;
  set title(value) => this._title = value;

  get icon => this._icon;
  set icon(value) => this._icon = value;

  bool get mode => _mode;
  set mode(value) => this._mode = value;
}
