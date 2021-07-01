import 'package:ble_control_app/devices/device.dart';
import 'package:ble_control_app/model/base_action.dart';
import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/home_page.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EndDrawerWidget extends StatefulWidget {
  
  Device _currentDevice;

  EndDrawerWidget() {
    if (_currentDevice == null) {
      _currentDevice = HomePage.devices.first;
    }
  }

  @override
  _EndDrawerWidgetState createState() => _EndDrawerWidgetState();
}

class _EndDrawerWidgetState extends State<EndDrawerWidget> {
  Widget _deviceChanger() {
    return Container (
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 7),
      alignment: Alignment.centerLeft,
      child: ElevatedButton.icon(
        icon: Icon(Icons.arrow_downward_rounded),
        label: AutoSizeText("Choose set", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), maxLines: 1,),
        onPressed: () => showCupertinoModalPopup(
          context: context, 
          builder: (_) => Container(
            height: 200,
            child: CupertinoPicker(
              backgroundColor: Colors.white,
              itemExtent: 40, 
              onSelectedItemChanged: (newValue) {
                setState(() {
                  widget._currentDevice = HomePage.devices.elementAt(newValue);
                });
              }, 
              children: HomePage.devices.map<AutoSizeText>((Device device) => 
                AutoSizeText(device.name, style: TextStyle(fontSize: 24),)).toList()
            ),
          )
        ) 
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 150, // TODO: constraints
            child: DrawerHeader(
              child: Align(
                alignment: Alignment.bottomRight,
                child: AutoSizeText(
                  widget._currentDevice.name + ' actions',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  maxLines: 1,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.lightGreen,
              ),
            ),
          ),
          _deviceChanger(),
          Divider()
        ] + getDeviceActionsWidgets(widget._currentDevice),
      ),
    );
  }
}

List<Widget> getDeviceActionsWidgets(Device device) {
  List<Widget> widgets = <Widget>[];

  for (var action in device.actions) {
    widgets.add(ActionWidget(action(), () {
            HomeGridView.globalKey.currentState.addGridElement(Tile(
              TileSize(1, 1), TilePosition(0, 0), action()));
          }));
  }
  return widgets;
}

class ActionWidget extends StatelessWidget {
  final BaseAction _action;
  final Function _creationFunc;

  ActionWidget(this._action, this._creationFunc);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: AutoSizeText(
          _action.title,
          maxLines: 2,
        ),
        leading: _action.icon,
        onTap: () {
          _creationFunc();
          Navigator.pop(context);
        });
  }
}
