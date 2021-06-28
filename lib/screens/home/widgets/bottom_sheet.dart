import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/home_page.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditingModalBottomSheet extends StatefulWidget {
  //TODO: Работать с копией и сохранять на Done (copyWith())
  final Tile _tile;
  final GlobalKey<DraggableButtonState> _draggableButtonState;

  EditingModalBottomSheet(this._tile, this._draggableButtonState);

  @override
  _EditingModalBottomSheetState createState() =>
      _EditingModalBottomSheetState();
}

class _EditingModalBottomSheetState extends State<EditingModalBottomSheet> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _updateState(Function updatingFunction) {
    setState(() {
      widget._draggableButtonState.currentState.setState(() {
        updatingFunction();
      });
    });
  }

  Widget _sizeDropDownButton(bool axis, int dropdownValue) {
    return DropdownButton<int>(
      value: dropdownValue,
      underline: Container(
        height: 1,
      ),
      onChanged: (int newValue) {
        bool hasPlace = HomeGridView.globalKey.currentState
            .hasPlaceExcludingOldButton(
                widget._tile.position.x,
                widget._tile.position.y,
                axis ? newValue : widget._tile.size.width,
                axis ? widget._tile.size.height : newValue,
                widget._tile.size.width,
                widget._tile.size.height,
                widget._tile.position.x,
                widget._tile.position.y);
        if (hasPlace) {
          _updateState(() {
            HomeGridView.globalKey.currentState.resizeTileAndRebuild(
              widget._tile,
              axis ? newValue : widget._tile.size.width,
              axis ? widget._tile.size.height : newValue,
            );
          });
        } else {
          final scaffoldMessenger =
              ScaffoldMessenger.of(_scaffoldKey.currentContext);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Cannot resize button: not enough space'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString(),
            style: TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomSheetHeight = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            height: bottomSheetHeight,
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Scrollbar(
              child: ListView(
                children: <Widget>[
                  Container(
                    // Title
                    height: 45,
                    child: ListTile(
                        title: AutoSizeText(
                      "\"" + widget._tile.action.title + "\" settings",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    )),
                  ),
                  Container(
                    // Change Name
                    height: 100,
                    padding: EdgeInsets.only(right: 15),
                    child: TextFormField(
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.edit, color: Colors.black38),
                          border: UnderlineInputBorder(),
                          labelText: "Edit name",
                          labelStyle: TextStyle(color: Colors.black38)),
                      maxLength: 20,
                      initialValue: widget._tile.action.title,
                      onChanged: (text) {
                        _updateState(() {
                          widget._tile.action.title = text;
                        });
                      },
                    ),
                  ),
                  Container(
                    // Mode Switch
                    height: bottomSheetHeight * 0.25,
                    padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "switch",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: widget._tile.action.mode,
                            onChanged: (bool value) {
                              setState(() {
                                widget._tile.action.mode = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          "hold",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // Pin Slider
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
                  ),
                  Container(
                    // SizeChanger
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "width:",
                        ),
                        _sizeDropDownButton(true, widget._tile.size.width),
                        Text(
                          "height:",
                        ),
                        _sizeDropDownButton(false, widget._tile.size.height)
                      ],
                    ),
                  ),
                  Container(
                    // Done Button
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
                        HomeGridView.globalKey.currentState.setState(() {
                          HomePage.homepageKey.currentState.isEditing = false;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
