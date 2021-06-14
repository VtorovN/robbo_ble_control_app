import 'package:ble_control_app/model/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Helper functions for enum
// String enumToString(Object o) => o.toString().split('.').last;
// T enumFromString<T>(String key, List<T> values) => values.firstWhere((v) => key == enumToString(v), orElse: () => null);

class Pin {

}

class BaseAction {
  String _title;
  Icon _icon;

  Size _size;
  Function _onPressed;
  bool _mode; // High-Low
  double _pin;
  
  BaseAction(this._title, this._icon) {
    _size = Size(1, 1);
    _onPressed = () {};
    _mode = false;
    _pin = 1;
  }

  void changeMode() {
    _mode = !_mode;
  }

  Function get onPressed => _onPressed;
  set onPressed(Function value) => this._onPressed = value;

  double get pin => this._pin;
  set pin(double value) => this._pin = value;

  get title => this._title;
  set title( value) => this._title = value;

  get size => this._size;
  set size( value) => this._size = value;

  get icon => this._icon;
  set icon( value) => this._icon = value;

  bool get mode => _mode;
  set mode(bool value) => this._mode = value;
}

class BaseActionWidget extends StatefulWidget {
  BaseAction _action;
  Function _creationFunc;
  BaseActionWidget(this._action, this._creationFunc);

  @override
  State<StatefulWidget> createState() => _BaseActionWidgetState();
}

class _BaseActionWidgetState extends State<BaseActionWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
              widget._action._title,
              style: CommonValues.actionTextStyle,
            ),
            leading: widget._action._icon,
            onTap: () {
              widget._creationFunc();
              Navigator.pop(context);
            }
    );
  }
}
