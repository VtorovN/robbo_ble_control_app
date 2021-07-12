import 'package:auto_size_text/auto_size_text.dart';
import 'package:ble_control_app/model/tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';
import 'editing_bottom_sheet.dart';

class DraggableButton extends StatefulWidget {
  final Tile _tile;
  final int posX;
  final int posY;
  final key = GlobalKey<DraggableButtonState>();

  Tile get tile => this._tile;

  DraggableButton(this.posX, this.posY, this._tile);

  @override
  DraggableButtonState createState() => new DraggableButtonState();
}

class DraggableButtonState extends State<DraggableButton> {
  EditingModalBottomSheet _bottomSheet;

  @override
  void initState() { 
    super.initState();
    _bottomSheet = EditingModalBottomSheet(widget._tile, widget.key);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return LongPressDraggable<DraggableButton>(
        data: widget,
        feedback: Opacity(
          opacity: 0.5,
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Material(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: AutoSizeText(
                      widget.tile.action.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      maxLines: 2,
                      wrapWords: false,
                      overflow: TextOverflow.clip,
                    )),
              ),
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            if (HomePage.homepageKey.currentState.isEditing) {
              var modalBottomSheet = showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
                builder: (context) =>
                  _bottomSheet //TODO: как и что передавать?
              );
              modalBottomSheet.whenComplete(
                () => HomePage.homepageKey.currentState.setState(() {
                    HomePage.homepageKey.currentState.isEditing = false;
                  }));
            } else {
              widget.tile.action.onPressed();
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            primary: Colors.green.shade300),
          child: Container(
            child: AutoSizeText(
              widget.tile.action.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
              maxLines: 2,
              wrapWords: false,
              overflow: TextOverflow.clip,
              minFontSize: 6,
          ))),
      );
    });
  }
}
