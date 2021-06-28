import 'package:ble_control_app/model/action.dart';
import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/home_page.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EndDrawerWidget extends StatelessWidget {
  EndDrawerWidget();

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
                child: Text('Add action',
                    style: TextStyle(fontSize: 30, color: Colors.white)),
              ),
              decoration: BoxDecoration(
                color: Colors.lightGreen,
              ),
            ),
          ),
          BaseActionWidget(HomePage.otto.action(), () {
            HomeGridView.globalKey.currentState.addGridElement(Tile(
                TileSize(1, 1), TilePosition(0, 0), HomePage.otto.action()));
          }),
          BaseActionWidget(HomePage.otto.blink(), () {
            HomeGridView.globalKey.currentState.addGridElement(Tile(
                TileSize(1, 1), TilePosition(0, 0), HomePage.otto.blink()));
          }),
          BaseActionWidget(HomePage.otto.move(), () {
            HomeGridView.globalKey.currentState.addGridElement(
                Tile(TileSize(1, 1), TilePosition(0, 0), HomePage.otto.move()));
          }),
          BaseActionWidget(HomePage.otto.sound(), () {
            HomeGridView.globalKey.currentState.addGridElement(Tile(
                TileSize(1, 1), TilePosition(0, 0), HomePage.otto.sound()));
          }),
        ],
      ),
    );
  }
}

class BaseActionWidget extends StatelessWidget {
  final BaseAction _action;
  final Function _creationFunc;

  BaseActionWidget(this._action, this._creationFunc);

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
