import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/home_page.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';
import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  Tile _originalTile;
  Tile _bufTile;
  final GlobalKey<DraggableButtonState> _draggableButtonState;

  SaveButton(this._originalTile, this._bufTile, this._draggableButtonState);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.only(right: 15),
      child: ElevatedButton.icon(
        icon: Icon(Icons.save_outlined, size: 20),
        label: Text('Save',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () {
          _draggableButtonState.currentState.setState(() {
            _originalTile.matchTo(_bufTile);
          });
          HomePage.homepageKey.currentState.setState(() {
            HomePage.homepageKey.currentState.isEditing = false;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}