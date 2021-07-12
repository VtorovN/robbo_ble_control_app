import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/widgets/draggable_button.dart';
import 'package:flutter/material.dart';

import 'bottom_sheet_widget.dart';

class PinSlider implements BottomSheetWidget {
  PinSlider();
  Widget get(Tile bufTile, Tile tile, GlobalKey<DraggableButtonState> draggableButtonState, GlobalKey<ScaffoldState> scaffoldKey)
    => PinSliderWidget(bufTile);
}

class PinSliderWidget extends StatefulWidget {
  final Tile _tile;
  
  PinSliderWidget(this._tile);

  @override
  _PinSliderWidgetState createState() => _PinSliderWidgetState();
}

class _PinSliderWidgetState extends State<PinSliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Pin",
          ),
          SliderTheme(
              data: SliderThemeData(
                trackShape: RectangularSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 12.0),
                overlayShape:
                    RoundSliderOverlayShape(overlayRadius: 28.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.83,
                child: Slider(
                  min: 1,
                  max: 32,
                  divisions: 31,
                  label:
                      widget._tile.action.pin.toInt().toString(),
                  value: widget._tile.action.pin,
                  onChanged: (value) {
                    setState(() {
                      widget._tile.action.pin = value;
                    });
                  },
                ),
              ))
        ],
      ),
    );
  }
}