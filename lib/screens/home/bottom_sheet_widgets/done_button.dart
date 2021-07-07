import 'package:ble_control_app/screens/home/home_page.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';
import 'package:flutter/material.dart';

class DoneButton extends StatelessWidget {
  final GlobalKey<DraggableButtonState> _draggableButtonState;

  DoneButton(this._draggableButtonState);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.only(right: 15),
      child: ElevatedButton.icon(
        icon: Icon(Icons.done, size: 20),
        label: Text('Done',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () {
          HomePage.homepageKey.currentState.setState(() {
            HomePage.homepageKey.currentState.isEditing = false;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}