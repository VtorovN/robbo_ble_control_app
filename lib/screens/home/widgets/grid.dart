import 'package:ble_control_app/model/tile.dart';
import 'package:ble_control_app/screens/home/home_page.dart';
import 'package:ble_control_app/screens/home/widgets/bottom_sheet.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeGridView extends StatefulWidget {
  static final GlobalKey<_HomeGridViewState> _homeActionButtonsKey =
      GlobalKey<_HomeGridViewState>();
  final int _gridSize = 36;
  final int _crossAxisCount = 4;

  static GlobalKey<_HomeGridViewState> get globalKey => _homeActionButtonsKey;

  HomeGridView() : super(key: _homeActionButtonsKey);

  @override
  State<StatefulWidget> createState() => new _HomeGridViewState();
}

class _HomeGridViewState extends State<HomeGridView>
    with TickerProviderStateMixin {
  Ticker scrollTicker;
  ScrollController gridScrollController = ScrollController();
  List<List<_GridLayoutCellPlaceholder>> _gridCellsLayout;
  List<StaggeredTileWithDraggableData> _staggeredGridViewChildren;
  List<StaggeredTile> _staggeredTiles;

  bool hasPlace(int posX, int posY, int width, int height) {
    if (posX + width - 1 >= _gridCellsLayout.length ||
        posY + height - 1 >= _gridCellsLayout[0].length) {
      return false;
    }

    for (int i = posX; i < posX + width; i++) {
      for (int j = posY; j < posY + height; j++) {
        if (_gridCellsLayout[i][j].isOccupied) {
          return false;
        }
      }
    }

    return true;
  }

  bool hasPlaceExcludingButton(int buttonPosX, int buttonPosY, int buttonWidth,
      int buttonHeight, int posX, int posY) {
    if (posX + buttonWidth - 1 >= _gridCellsLayout.length ||
        posY + buttonHeight - 1 >= _gridCellsLayout[0].length) {
      return false;
    }

    for (int i = posX; i < posX + buttonWidth; i++) {
      for (int j = posY; j < posY + buttonHeight; j++) {
        if (!isIncluded(
            i, j, buttonPosX, buttonPosY, buttonWidth, buttonHeight)) {
          if (_gridCellsLayout[i][j].isOccupied) {
            return false;
          }
        }
      }
    }

    return true;
  }

  bool hasPlaceExcludingOldButton(
      int buttonPosX,
      int buttonPosY,
      int buttonWidth,
      int buttonHeight,
      int oldButtonWidth,
      int oldButtonHeight,
      int posX,
      int posY) {
    if (posX + buttonWidth - 1 >= _gridCellsLayout.length ||
        posY + buttonHeight - 1 >= _gridCellsLayout[0].length) {
      return false;
    }

    for (int i = posX; i < posX + buttonWidth; i++) {
      for (int j = posY; j < posY + buttonHeight; j++) {
        if (!isIncluded(
            i, j, buttonPosX, buttonPosY, oldButtonWidth, oldButtonHeight)) {
          if (_gridCellsLayout[i][j].isOccupied) {
            return false;
          }
        }
      }
    }

    return true;
  }

  bool isIncluded(int posX, int posY, int rectPosX, int rectPosY, int rectWidth,
      int rectHeight) {
    if (posX < rectPosX ||
        posY < rectPosY ||
        posX > rectPosX + rectWidth - 1 ||
        posY > rectPosY + rectHeight - 1) {
      return false;
    }

    return true;
  }

  void clearGrid() {
    _staggeredGridViewChildren = List.filled(0, null, growable: true);
    _staggeredTiles = List.filled(0, null, growable: true);

    _gridCellsLayout = List.generate(
        widget._crossAxisCount,
        (i) => List.generate(
            widget._gridSize ~/ widget._crossAxisCount, (i) => null));

    for (int i = 0; i < widget._crossAxisCount; i++) {
      for (int j = 0; j < widget._gridSize ~/ widget._crossAxisCount; j++) {
        _staggeredGridViewChildren
            .add(StaggeredTileWithDraggableData(i, j, false));
        _staggeredTiles.add(StaggeredTile.count(1, 1));
        _gridCellsLayout[i][j] = _GridLayoutCellPlaceholder(false, false);
      }
    }
  }

  void addGridElement(Tile tile) {
    if (tile.position.x < 0 ||
        tile.position.y < 0 ||
        tile.position.x >= _gridCellsLayout.length ||
        tile.position.y >= _gridCellsLayout[0].length) {
      throw ("Button position is out of range of grid");
    }

    if (!hasPlace(
        tile.position.x, tile.position.y, tile.size.width, tile.size.height)) {
      throw ('Tiles cannot overlap: position is occupied');
    }

    addTileAndRebuild(tile);
  }

  void _addTile(Tile tile) {
    _gridCellsLayout[tile.position.x][tile.position.y] =
        _GridLayoutCellPlaceholder(true, true, tile: tile);
    for (int i = 0; i < tile.size.width; i++) {
      for (int j = 0; j < tile.size.height; j++) {
        if (i == 0 && j == 0) {
          continue;
        }
        _gridCellsLayout[tile.position.x + i][tile.position.y + j] =
            _GridLayoutCellPlaceholder(false, true);
      }
    }
  }

  void addTileAndRebuild(Tile tile) {
    _addTile(tile);
    buildGrid();
  }

  void _removeTile(Tile tile) {
    for (int i = 0; i < tile.size.width; i++) {
      for (int j = 0; j < tile.size.height; j++) {
        _gridCellsLayout[tile.position.x + i][tile.position.y + j] =
            _GridLayoutCellPlaceholder(false, false);
      }
    }
  }

  void removeTileAndRebuild(Tile tile) {
    _removeTile(tile);
    buildGrid();
  }

  void _moveTile(Tile tile, int newX, int newY) {
    _removeTile(tile);
    tile.position = TilePosition(newX, newY);
    _addTile(tile);
  }

  void moveTileAndRebuild(Tile tile, int newX, int newY) {
    _moveTile(tile, newX, newY);
    buildGrid();
  }

  void _resizeTile(Tile tile, int newWidth, int newHeight) {
    _removeTile(tile);
    tile.size = TileSize(newWidth, newHeight);
    _addTile(tile);
  }

  void resizeTileAndRebuild(Tile tile, int newWidth, int newHeight) {
    _resizeTile(tile, newWidth, newHeight);
    buildGrid();
  }

  void buildGrid() {
    setState(() {
      _staggeredGridViewChildren = List.filled(0, null, growable: true);
      _staggeredTiles = List.filled(0, null, growable: true);

      for (int j = 0; j < _gridCellsLayout[0].length; j++) {
        for (int i = 0; i < _gridCellsLayout.length; i++) {
          if (_gridCellsLayout[i][j].isElementCell) {
            var element = StaggeredTileWithDraggableData(
              i,
              j,
              true,
              tile: _gridCellsLayout[i][j].tile,
            );

            _staggeredGridViewChildren.add(element);
            _staggeredTiles.add(StaggeredTile.count(
                _gridCellsLayout[i][j].tile.size.width,
                _gridCellsLayout[i][j].tile.size.height.toDouble()));
          } else if (_gridCellsLayout[i][j].isOccupied) {
            continue;
          } else {
            _staggeredGridViewChildren
                .add(StaggeredTileWithDraggableData(i, j, false));
            _staggeredTiles.add(StaggeredTile.count(1, 1));
          }
        }
      }
    });
  }

  Widget buildEdgeScroller(double offsetPerFrame) {
    return DragTarget<DraggableButton>(
      builder: (context, candidateData, rejectedData) => Container(),
      onWillAccept: (data) {
        scrollTicker = this.createTicker((elapsed) {
          if (!gridScrollController.hasClients) {
            return;
          }
          final position = gridScrollController.position;
          if ((offsetPerFrame < 0 &&
                  position.pixels <= position.minScrollExtent) ||
              (offsetPerFrame > 0 &&
                  position.pixels >= position.maxScrollExtent)) {
            scrollTicker.stop();
            scrollTicker.dispose();
            scrollTicker = null;
          } else {
            gridScrollController
                .jumpTo(gridScrollController.offset + offsetPerFrame);
          }
        });
        scrollTicker.start();
        return false;
      },
      onLeave: (data) {
        scrollTicker?.stop();
        scrollTicker?.dispose();
        scrollTicker = null;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    clearGrid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(5),
        child: Stack(
          children: [
            StaggeredGridView.count(
              crossAxisCount: widget._crossAxisCount,
              controller: gridScrollController,
              staggeredTiles: _staggeredTiles,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: _staggeredGridViewChildren,
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 25,
                child: buildEdgeScroller(-10)),
            Positioned(
                top: 25,
                left: 0,
                right: 0,
                height: 25,
                child: buildEdgeScroller(-5)),
            Positioned(
                bottom: 25,
                left: 0,
                right: 0,
                height: 25,
                child: buildEdgeScroller(5)),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 25,
                child: buildEdgeScroller(10)),
          ],
        ),
      ),
    );
  }
}

class StaggeredTileWithDraggableData extends StatelessWidget {
  final isDataTile;
  final int posX;
  final int posY;
  final Tile tile;

  StaggeredTileWithDraggableData(this.posX, this.posY, this.isDataTile,
      {this.tile});

  @override
  Widget build(BuildContext context) {
    if (isDataTile) {
      if (this.tile == null) {
        throw ('Need tile to build widget');
      }

      return DraggableButton(posX, posY, tile);
    } else {
      return DragTarget<DraggableButton>(
        builder: (context, candidates, rejects) {
          if (candidates.isEmpty) {
            return Container();
          } else {
            return Container(
                decoration: BoxDecoration(
              border: Border(
                top: BorderSide(),
                left: BorderSide(),
              ),
            ));
          }
        },
        onWillAccept: (value) {
          return value != null &&
              HomeGridView.globalKey.currentState.hasPlaceExcludingButton(
                  value.posX,
                  value.posY,
                  value.tile.size.width,
                  value.tile.size.height,
                  posX,
                  posY);
        },
        onAccept: (button) {
          HomeGridView.globalKey.currentState
              .moveTileAndRebuild(button.tile, posX, posY);
        },
      );
    }
  }
}

class _GridLayoutCellPlaceholder {
  // Means that this is exactly the cell where element is located
  final bool isElementCell;
  // Means that this cell is a part of an element
  final bool isOccupied;

  final Tile tile;

  _GridLayoutCellPlaceholder(this.isElementCell, this.isOccupied, {this.tile});
}

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
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    )),
              ),
            ),
          ),
        ),
        child: ElevatedButton(
            onPressed: () {
              if (HomePage.homepageKey.currentState.isEditing) {
                showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    builder: (context) =>
                        EditingModalBottomSheet(widget.tile, widget.key));
              } else {
                widget.tile.action.onPressed();
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                primary: Colors.green.shade300),
            child: AutoSizeText(
              widget.tile.action.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
              maxLines: 2,
              overflow: TextOverflow.clip,
            )),
      );
    });
  }
}
