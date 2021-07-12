import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/widgets/draggable_button.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';
import 'package:flutter/material.dart';

import 'bottom_sheet_widget.dart';

class SizeChanger implements BottomSheetWidget {
  SizeChanger();
  Widget get(Tile bufTile, Tile tile, GlobalKey<DraggableButtonState> draggableButtonState, GlobalKey<ScaffoldState> scaffoldKey)
    => SizeChangerWidget(bufTile, scaffoldKey);
}

class SizeChangerWidget extends StatefulWidget {
  final Tile _tile;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  SizeChangerWidget(this._tile, this._scaffoldKey);

  @override
  _SizeChangerWidgetState createState() => _SizeChangerWidgetState();
}

class _SizeChangerWidgetState extends State<SizeChangerWidget> {
  int currentWidth;
  int currentHeight;

  Widget _sizeDropDownButton(bool axis, int dropdownValue) {
    return DropdownButton<int>(
      value: dropdownValue,
      underline: Container(
        height: 1,
      ),
      onChanged: (int newValue) {
        setState(() {
          axis ? currentWidth = newValue : currentHeight = newValue;
        });

        bool hasPlace = HomeGridView.globalKey.currentState
            .hasPlaceExcludingOldButton(
                widget._tile.position.x,
                widget._tile.position.y,
                axis ? newValue : widget._tile.size.width,
                axis ? widget._tile.size.height : newValue,
                widget._tile.size.width,
                widget._tile.size.height,
                widget._tile.position.x,
                widget._tile.position.y);
        if (hasPlace) {
          widget._tile.size = TileSize(
              axis ? newValue : widget._tile.size.width,
              axis ? widget._tile.size.height : newValue
          );
        } else {
          final scaffoldMessenger =
              ScaffoldMessenger.of(widget._scaffoldKey.currentContext);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Cannot resize button: not enough space'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString(),
            style: TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    currentWidth = widget._tile.size.width;
    currentHeight = widget._tile.size.height;

    return Container(
      // SizeChanger
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "width:",
          ),
          _sizeDropDownButton(true, currentWidth),
          Text(
            "height:",
          ),
          _sizeDropDownButton(false, currentHeight)
        ],
      ),
    );
  }
}