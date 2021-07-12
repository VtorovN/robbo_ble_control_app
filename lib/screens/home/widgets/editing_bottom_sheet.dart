import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/widgets/draggable_button.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditingModalBottomSheet extends StatefulWidget {
  final Tile _tile;
  final GlobalKey<DraggableButtonState> _draggableButtonState;

  EditingModalBottomSheet(this._tile, this._draggableButtonState);

  @override
  _EditingModalBottomSheetState createState() =>
      _EditingModalBottomSheetState();
}

class _EditingModalBottomSheetState extends State<EditingModalBottomSheet> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Tile bufTile;

  @override
  void initState() {
    super.initState();
    bufTile = Tile.clone(widget._tile);
  }

  @override
  Widget build(BuildContext context) {
    final double bottomSheetHeight = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: Container(
          height: bottomSheetHeight,
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Scrollbar(
            child: ListView(
              children: widget._tile.widgets.map(
                (e) => e.get(bufTile, widget._tile, widget._draggableButtonState, widget.key)).toList()
            )
          )
        )
    );
  }
}  