import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/bottom_sheet_topbar.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/name_changer.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/pin_slider.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/size_changer.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/switcher.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditingModalBottomSheet extends StatefulWidget {
  final Tile _tile;
  final Tile _bufTile; //TODO: Работать с копией и сохранять на Save
  // final List<Widget> _widgets; // TODO: Может так?
  final GlobalKey<DraggableButtonState> _draggableButtonState;

  EditingModalBottomSheet(this._tile, this._draggableButtonState)
      : _bufTile = Tile.clone(_tile);

  @override
  _EditingModalBottomSheetState createState() =>
      _EditingModalBottomSheetState();
}

class _EditingModalBottomSheetState extends State<EditingModalBottomSheet> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final double bottomSheetHeight = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
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
                children: <Widget>[
                  BottomSheetTopBar(widget._tile, widget._bufTile, widget._draggableButtonState),
                  NameChanger(widget._bufTile),
                  ModeSwitcher(widget._bufTile),
                  PinSlider(widget._bufTile),
                  SizeChanger(widget._bufTile, _scaffoldKey),
                ],
              ),
            )));
  }
}
