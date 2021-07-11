import 'package:ble_control_app/actions/basic_action.dart';
import 'package:flutter/src/widgets/icon.dart';

class BlinkAction extends BasicAction {
  BlinkAction(String title, Icon icon, Function onPressed, bool mode, double pin)
   : super(title, icon, onPressed, mode, pin);
 

}