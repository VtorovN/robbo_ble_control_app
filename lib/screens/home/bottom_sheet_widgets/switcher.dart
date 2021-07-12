import 'package:auto_size_text/auto_size_text.dart';
import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/bottom_sheet_widget.dart';
import 'package:ble_control_app/screens/home/widgets/draggable_button.dart';
import 'package:flutter/material.dart';

class ModeSwitcher implements BottomSheetWidget {
  ModeSwitcher();
  Widget get(Tile bufTile, Tile tile, GlobalKey<DraggableButtonState> draggableButtonState, GlobalKey<ScaffoldState> scaffoldKey)
    => ModeSwitcherWidget(bufTile);
}

class ModeSwitcherWidget extends StatefulWidget {
  final Tile _tile;
  
  ModeSwitcherWidget(this._tile);

  @override
  _ModeSwitcherWidgetState createState() => _ModeSwitcherWidgetState();
}

class _ModeSwitcherWidgetState extends State<ModeSwitcherWidget> {
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
          AutoSizeText(
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
          AutoSizeText(
            "hold",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}