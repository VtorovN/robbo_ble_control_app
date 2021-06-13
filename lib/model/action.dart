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
  BaseAction(this._creatingFunc, this._onPressed, this._title, this._icon);

  void create() {
    _creatingFunc();
  }

  void make() {
    _onPressed();
  }

  Icon get icon => _icon;

  set icon(Icon value) {
    _icon = value;
  }

  Size get size => _size;

  set size(Size value) {
    _size = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  Pin get pin => _pin;

  set pin(Pin value) {
    _pin = value;
  }

  bool get mode => _mode;

  set mode(bool value) {
    _mode = value;
  }

  Function get onPressed => _onPressed;

  set onPressed(Function value) {
    _onPressed = value;
  }
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