import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:ble_control_app/screens/home/widgets/draggable_button.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BulbColorPicker extends BottomSheetWidget {
  @override
  Widget get(Tile bufTile, Tile tile, GlobalKey<DraggableButtonState> draggableButtonState, GlobalKey<ScaffoldState> scaffoldKey) 
    => BulbColorPickerWidget(bufTile);
}

class BulbColorPickerWidget extends StatefulWidget {
  final Tile _tile;

  BulbColorPickerWidget(this._tile);

  @override
  _BulbColorPickerWidgetState createState() => _BulbColorPickerWidgetState();
}

class _BulbColorPickerWidgetState extends State<BulbColorPickerWidget> {
  Color currentColor = Colors.green;
  List<Color> currentColors = [Colors.green, Colors.white];

  void changeColor(Color color) => setState(() => currentColor = color);
  void changeColors(List<Color> colors) => setState(() => currentColors = colors);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              titlePadding: const EdgeInsets.all(0.0),
              contentPadding: const EdgeInsets.all(0.0),
              content: ColorPicker(
                pickerColor: currentColor,
                onColorChanged: changeColor,
                colorPickerWidth: 300.0,
                pickerAreaHeightPercent: 1,
                enableAlpha: true,
                displayThumbColor: true,
                showLabel: true,
                paletteType: PaletteType.hsv,
                pickerAreaBorderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(2.0),
                  topRight: const Radius.circular(2.0),
                ),
              ),
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        primary: currentColor,
        textStyle: TextStyle(color: const Color(0xff000000),),
      ),
      child: const Text('Change me'),
    );
  }
}