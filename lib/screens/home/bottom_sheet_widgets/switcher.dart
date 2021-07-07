import 'package:ble_control_app/model/tile.dart';
import 'package:flutter/material.dart';

class ModeSwitcher extends StatefulWidget {
  Tile _tile;
  
  ModeSwitcher(this._tile);

  @override
  _ModeSwitcherState createState() => _ModeSwitcherState();
}

class _ModeSwitcherState extends State<ModeSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Mode Switch
      height: MediaQuery.of(context).size.height * 0.6 * 0.25,
      padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "switch",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Transform.scale(
            scale: 1.5,
            child: Switch(
              value: widget._tile.action.mode,
              onChanged: (bool value) {
                setState(() {
                  widget._tile.action.mode = value;
                });
              },
            ),
          ),
          Text(
            "hold",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}