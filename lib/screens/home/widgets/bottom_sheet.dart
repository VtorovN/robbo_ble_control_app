import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/done_button.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/name_changer.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/pin_slider.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/size_changer.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/switcher.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditingModalBottomSheet extends StatefulWidget {
  final Tile _tile;
  final List<Widget> _widgets;
  final GlobalKey<DraggableButtonState> _draggableButtonState;

  EditingModalBottomSheet(this._tile, this._widgets, this._draggableButtonState);

  @override
  _EditingModalBottomSheetState createState() =>
      _EditingModalBottomSheetState();
}

class _EditingModalBottomSheetState extends State<EditingModalBottomSheet> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Tile _bufTile;  //TODO: Работать с копией и сохранять на Done (copyWith())

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
                children: widget._widgets
              ),
            )));
  }
}


// <Widget>[
//   BottomSheetTitle(widget._tile),
//   NameChanger(widget._tile, widget._draggableButtonState),
//   ModeSwitcher(widget._tile),
//   PinSlider(widget._tile),
//   SizeChanger(widget._tile, widget._draggableButtonState),
//   DoneButton(widget._draggableButtonState)
// ],