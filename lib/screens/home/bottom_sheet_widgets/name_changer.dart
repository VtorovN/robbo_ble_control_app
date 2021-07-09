import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';
import 'package:flutter/material.dart';

class NameChanger extends StatefulWidget {
  final Tile _tile;

  NameChanger(this._tile);

  @override
  _NameChangerState createState() => _NameChangerState();
}

class _NameChangerState extends State<NameChanger> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.only(right: 15),
      child: TextFormField(
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.edit, color: Colors.black38),
            border: UnderlineInputBorder(),
            labelText: "Edit name",
            labelStyle: TextStyle(color: Colors.black38)),
        maxLength: 20,
        initialValue: widget._tile.action.title,
        onChanged: (text) {
          setState(() {
            widget._tile.action.title = text;
          });
        },
      ),
    );
  }
}