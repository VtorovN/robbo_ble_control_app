import 'package:ble_control_app/model/tile.dart';
import 'package:flutter/material.dart';

class PinSlider extends StatefulWidget {
  final Tile _tile;
  
  PinSlider(this._tile);

  @override
  _PinSliderState createState() => _PinSliderState();
}

class _PinSliderState extends State<PinSlider> {
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