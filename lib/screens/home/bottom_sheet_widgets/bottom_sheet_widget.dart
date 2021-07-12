import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/widgets/draggable_button.dart';
import 'package:flutter/material.dart';

abstract class BottomSheetWidget {
  BottomSheetWidget();
  Widget get(Tile bufTile, Tile tile, GlobalKey<DraggableButtonState> draggableButtonState, GlobalKey<ScaffoldState> scaffoldKey);
}