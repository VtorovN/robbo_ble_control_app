import 'package:ble_control_app/actions/basic_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/bottom_sheet_widget.dart';


class BlinkAction extends BasicAction {
  Color _color;

  BlinkAction(String title, Icon icon, Function onPressed, bool mode, double pin, List<BottomSheetWidget> widgets) 
    : super(title, icon, onPressed, mode, pin, widgets);


}