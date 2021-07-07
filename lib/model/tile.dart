import 'package:ble_control_app/actions/base_action.dart';
import 'package:flutter/material.dart';

class TileSize {
  int _height;
  int _width;

  TileSize(this._width, this._height);
  TileSize.clone(TileSize original): this(original.width, original.height);

  get height => this._height;
  set height(int value) => this._height = value;

  get width => this._width;
  set width(int value) => this._width = value;
}

class TilePosition {
  int _x;
  int _y;

  TilePosition(this._x, this._y);
  TilePosition.clone(TilePosition original): this(original.x, original.y);

  get x => this._x;
  set x(int value) => this._x = value;

  get y => this._y;
  set y(int value) => this._y = value;
}

class Tile {
  TileSize _size;
  TilePosition _position;
  BaseAction _action;

  Tile(this._size, this._position, this._action);
  Tile.clone(Tile original): this(TileSize.clone(original.size), TilePosition.clone(original.position), BaseAction.clone(original.action));

  get size => this._size;
  set size(value) => this._size = value;

  get position => this._position;
  set position(value) => this._position = value;

  get action => this._action;
  set action(value) => this.action = value;
}
