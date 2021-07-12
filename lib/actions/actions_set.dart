import 'package:ble_control_app/actions/basic_action.dart';
import 'package:ble_control_app/actions/blink_action.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/bottom_sheet_topbar.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/bottom_sheet_widget.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/bulb_color_picker.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/name_changer.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/pin_slider.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/size_changer.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/switcher.dart';
import 'package:flutter/material.dart';

class ActionsSet { // Реализация Одного набора
  String _name;
  List<Function> _actions = <Function>[];

  ActionsSet(this._name);

  String get name => _name;
  List<Function> get actions => _actions;

  static BasicAction button() => BasicAction(
      "Button",
      Icon(Icons.create),
      () {},
      false,
      1,
      <BottomSheetWidget>[
        BottomSheetTopBar(),
        NameChanger(),
        ModeSwitcher(),
        PinSlider(),
        SizeChanger(),
      ]
  );

  static BlinkAction blink() => BlinkAction(
      "Blink",
      Icon(Icons.lightbulb),
      () {},
      false,
      1,
      <BottomSheetWidget>[
        BottomSheetTopBar(),
        NameChanger(),
        BulbColorPicker(),
        ModeSwitcher(),
        SizeChanger(),
      ]
  );

  static BasicAction move() => BasicAction(
      "Move",
      Icon(Icons.accessibility),
      () {},
      false,
      1,
      <BottomSheetWidget>[
        BottomSheetTopBar(),
        NameChanger(),
        SizeChanger(),
      ]
  );

  static BasicAction sound () => BasicAction(
      "Sound",
      Icon(Icons.audiotrack),
      () {},
      false,
      1,
      <BottomSheetWidget>[
        BottomSheetTopBar(),
        NameChanger(),
        ModeSwitcher(),
        SizeChanger(),
      ]
  );

  static BasicAction turnLeft() => BasicAction(
      "Turn Left",
      Icon(Icons.arrow_left),
      () {},
      false,
      1,
      <BottomSheetWidget>[
        BottomSheetTopBar(),
        NameChanger(),
        SizeChanger(),
      ]
  );

  static BasicAction turnRight() => BasicAction(
      "Turn Right",
      Icon(Icons.arrow_right),
      () {},
      false,
      1,
      <BottomSheetWidget>[
        BottomSheetTopBar(),
        NameChanger(),
        SizeChanger(),
      ]
  );
}