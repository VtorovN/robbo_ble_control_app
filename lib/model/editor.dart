import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/widgets/editing_bottom_sheet.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';
import 'package:flutter/material.dart';

class Editor { // TODO: нужен ли вообще этот класс
  List<Widget> _elements;
  EditingModalBottomSheet _editingModalBottomSheet;

  Editor(this._elements, Tile tile, GlobalKey<DraggableButtonState> draggableButtonState) 
    : _editingModalBottomSheet = EditingModalBottomSheet(tile, draggableButtonState);

  EditingModalBottomSheet get bottomSheet => _editingModalBottomSheet;
}