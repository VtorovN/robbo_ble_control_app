import 'package:auto_size_text/auto_size_text.dart';
import 'package:ble_control_app/model/tile.dart';
import 'package:flutter/material.dart';

class BottomSheetTitle extends StatefulWidget {
  final Tile _tile;

  BottomSheetTitle(this._tile);

  @override
  _BottomSheetTitleState createState() => _BottomSheetTitleState();
}

class _BottomSheetTitleState extends State<BottomSheetTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Title
      height: 45,
      child: ListTile(
          title: AutoSizeText(
        "\"" + widget._tile.action.title + "\" settings",
        style:
            TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        maxLines: 1,
      )),
    );
  }
}