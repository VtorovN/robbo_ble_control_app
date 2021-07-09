import 'package:auto_size_text/auto_size_text.dart';
import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class BottomSheetTopBar extends StatefulWidget {
  final Tile _originalTile;
  final Tile _bufTile;
  final GlobalKey<DraggableButtonState> _draggableButtonState;

  BottomSheetTopBar(this._originalTile, this._bufTile, this._draggableButtonState);

  @override
  _BottomSheetTopBarState createState() => _BottomSheetTopBarState();
}

class _BottomSheetTopBarState extends State<BottomSheetTopBar> {
  @override
  Widget build(BuildContext context) {
    return 
    Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            child: AutoSizeText(
              "\"" + widget._bufTile.action.title + "\" settings",
              style:
                  TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.save_outlined, size: 20),
            label: AutoSizeText('save',
              style: TextStyle(
                fontSize: 23, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () {
              widget._draggableButtonState.currentState.setState(() {
                widget._originalTile.matchTo(widget._bufTile);
              });
              HomePage.homepageKey.currentState.setState(() {
                HomePage.homepageKey.currentState.isEditing = false;
              });
              Navigator.pop(context);
            },
          ),
        ],
      )
    ); 
  }
}