import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/bottom_sheet_widget.dart';
import 'package:ble_control_app/screens/home/widgets/draggable_button.dart';
import 'package:flutter/material.dart';

class NameChanger implements BottomSheetWidget {
  NameChanger();
  @override
  Widget get(Tile bufTile, Tile tile, GlobalKey<DraggableButtonState> draggableButtonState, GlobalKey<ScaffoldState> scaffoldKey)
    => NameChangerWidget(bufTile);
}

class NameChangerWidget extends StatefulWidget {
  final Tile _tile;

  NameChangerWidget(this._tile);

  @override
  _NameChangerWidgetState createState() => _NameChangerWidgetState();
}

class _NameChangerWidgetState extends State<NameChangerWidget> {
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
        onFieldSubmitted: (text) {
          setState(() {
            widget._tile.action.title = text;
          });
        },
      ),
    );
  }
}