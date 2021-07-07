import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';
import 'package:flutter/material.dart';

class SizeChanger extends StatefulWidget {
  Tile _tile;
  GlobalKey<DraggableButtonState> _draggableButtonState;

  SizeChanger(this._tile, this._draggableButtonState);

  @override
  _SizeChangerState createState() => _SizeChangerState();
}

class _SizeChangerState extends State<SizeChanger> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _sizeDropDownButton(bool axis, int dropdownValue) {
    return DropdownButton<int>(
      value: dropdownValue,
      underline: Container(
        height: 1,
      ),
      onChanged: (int newValue) {
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
          setState(() {
            HomeGridView.globalKey.currentState.resizeTileAndRebuild(
              widget._tile,
              axis ? newValue : widget._tile.size.width,
              axis ? widget._tile.size.height : newValue,
            );
          });
        } else {
          final scaffoldMessenger =
              ScaffoldMessenger.of(_scaffoldKey.currentContext);
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
    return Container(
      // SizeChanger
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "width:",
          ),
          _sizeDropDownButton(true, widget._tile.size.width),
          Text(
            "height:",
          ),
          _sizeDropDownButton(false, widget._tile.size.height)
        ],
      ),
    );
  }
}