import 'package:ble_control_app/actions/basic_action.dart';
import 'package:ble_control_app/screens/home/bottom_sheet_widgets/bottom_sheet_widget.dart';
import 'package:ble_control_app/screens/home/widgets/grid.dart';
import 'package:flutter/material.dart';

class TileSize {
  int _height;
  int _width;

  TileSize(this._width, this._height);
  TileSize.clone(TileSize original): this(original.width, original.height);

  get height => _height;
  set height(int value) => _height = value;

  get width => _width;
  set width(int value) => _width = value;
}

class TilePosition {
  int _x;
  int _y;

  TilePosition(this._x, this._y);
  TilePosition.clone(TilePosition original): this(original.x, original.y);

  get x => _x;
  set x(int value) => _x = value;

  get y => _y;
  set y(int value) => _y = value;
}

class Tile {
  TileSize _size;
  TilePosition _position;
  BasicAction _action;

  Tile(this._size, this._position, this._action);
  Tile.clone(Tile original): this(TileSize.clone(original.size), TilePosition.clone(original.position), BasicAction.clone(original.action));

  void matchTo(Tile tile) {
    _action.matchTo(tile.action);
    HomeGridView.globalKey.currentState.resizeTileAndRebuild(
      tile,
      tile.size.width,
      tile.size.height,
    );
  }

  List<BottomSheetWidget> get widgets => _action.widgets;

  get size => _size;
  set size(value) => _size = value;

  get position => _position;
  set position(value) => _position = value;

  get action => _action;
  set action(value) => _action = value;
}