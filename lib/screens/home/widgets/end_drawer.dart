import 'package:ble_control_app/actions/actions_set.dart';
import 'package:ble_control_app/actions/basic_action.dart';
import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/home_page.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EndDrawerWidget extends StatefulWidget {
  @override
  _EndDrawerWidgetState createState() => _EndDrawerWidgetState();
}

class _EndDrawerWidgetState extends State<EndDrawerWidget> {
  ActionsSet _currentActionsSet = ActionsSet("empty");

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
                  _currentActionsSet = HomePage.sets.getSet(HomePage.devices.elementAt(newValue).name);
                });
              }, 
              children: HomePage.sets.get.keys.map<AutoSizeText>((String set) => 
                AutoSizeText(set, style: TextStyle(fontSize: 24), maxLines: 1,)).toList()
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
                  "Set " + _currentActionsSet.name,
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
        ] + getDeviceActionsWidgets(_currentActionsSet),
      ),
    );
  }
}

List<Widget> getDeviceActionsWidgets(ActionsSet set) {
  List<Widget> widgets = <Widget>[];

  for (var action in set.actions) {
    widgets.add(ActionWidget(action(), _creationFunc(action())));
  }
  return widgets;
}

Function _creationFunc(BasicAction action) => 
  () => HomeGridView.globalKey.currentState.addGridElement(Tile(TileSize(1, 1), TilePosition(0, 0), action));

class ActionWidget extends StatelessWidget {
  final BasicAction _action;
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
