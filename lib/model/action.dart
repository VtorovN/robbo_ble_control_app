import 'package:ble_control_app/model/utils.dart';
import 'package:flutter/material.dart';

// Helper functions for enum
// String enumToString(Object o) => o.toString().split('.').last;
// T enumFromString<T>(String key, List<T> values) => values.firstWhere((v) => key == enumToString(v), orElse: () => null);

class Pin {

}

class BaseAction {
  Function _creatingFunc;
  Function _onPressed;
  bool _mode; // High-Low
  Pin _pin;

  String _title;
  Size _size;
  Icon _icon;
  BaseAction(this._title, this._icon);

  void create() {
    _creatingFunc();
  }

  void make() {
    _onPressed();
  }

  Function get creatingFunc => this._creatingFunc;
  set creatingFunc(Function value) => this._creatingFunc = value;

  Function get onPressed => _onPressed;
  set onPressed(Function value) => this._onPressed = value;

  Pin get pin => this._pin;
  set pin(Pin value) => this._pin = value;

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
  BaseActionWidget(this._action);

  @override
  State<StatefulWidget> createState() => BaseActionWidgetState();
}

class BaseActionWidgetState extends State<BaseActionWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
              widget._action._title,
              style: CommonValues.actionTextStyle,
            ),
            leading: widget._action._icon,
            onTap: () {
              Navigator.pop(context);
              showBottomSheet(
                context: context, 
                builder: (context) => _buildBottomSheet(context));
            },
    );
  }

  Container _buildBottomSheet(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListView(
        children: <Widget>[
          ListTile(title: Text(widget._action._title, style: CommonValues.bottomSheetTextStyle,)),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              icon: widget._action._icon,
              label: Text('Create ' + widget._action._title, style: CommonValues.bottomSheetTextStyle,),
              onPressed: () {
                widget._action.create();
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}