import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String? imagePath;

  DisplayPictureScreen({this.imagePath});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  List<DraggableItem> items = [];
  DraggableItem? selectedItem;
  double _scale = 1.0;
  double _previousScale = 1.0;

  final List<String> imagePaths = [
    'images/shokuzai_daikon_white.webp',
    'images/shokuzai_hourensou_green.webp',
    'images/shokuzai_ikasumi_black.webp',
    'images/shokuzai_kona_gray.webp',
    'images/shokuzai_korokke_blown.webp',
    'images/shokuzai_lemon_yellow.webp',
    'images/shokuzai_orange_orange.webp',
    'images/shokuzai_sauce_blown.webp',
    'images/shokuzai_tomato_red.webp',
    'images/shokuzai_trevise_purple.webp',
  ];

  void _deleteAllIcons() {
    setState(() {
      items.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem = null;
        });
      },
      onScaleStart: (ScaleStartDetails details) {
        if (selectedItem != null) {
          selectedItem!._previousScale = selectedItem!.scale;
        }
        setState(() {});
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        if (selectedItem != null) {
          selectedItem!.scale = selectedItem!._previousScale * details.scale;
          setState(() {});
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: _deleteAllIcons,
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(children: [
          Positioned.fill(
            child: widget.imagePath != null
                ? Image.file(
                    File(widget.imagePath!),
                    fit: BoxFit.fill,
                  )
                : Container(),
          ),
          ...items.map((item) {
            bool isSelected = selectedItem == item;
            double opacity = isSelected ? 0.7 : 1.0;
            Widget itemWidget = Transform.scale(
              scale: item.scale,
              child: Opacity(
                opacity: opacity,
                child: GestureDetector(
                  onLongPress: () {
                    if (isSelected) _removeItem(item);
                  },
                  onTap: () {
                    _selectItem(item);
                  },
                  child: _getShapeIcon(item),
                ),
              ),
            );

            return Positioned(
              left: item.position.dx,
              top: item.position.dy,
              child: isSelected
                  ? Draggable<String>(
                      data: item.imagePath,
                      feedback: Transform.scale(
                        scale: item.scale,
                        child: Opacity(
                          opacity: 0.7,
                          child: _getShapeIcon(item),
                        ),
                      ),
                      childWhenDragging: Container(),
                      child: itemWidget,
                      onDraggableCanceled: (velocity, offset) {
                        setState(() {
                          item.position = offset;
                        });
                      },
                    )
                  : itemWidget,
            );
          }).toList(),
        ]),
        bottomNavigationBar: _buildBottomAppBar(),
      ),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imagePaths.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildDraggableImage(imagePaths[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('images/shokuzai_main.webp', width: 50, height: 50),
                Image.asset('images/powderandsouse.webp',
                    width: 50, height: 50),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDraggableImage(String imagePath) {
    final Map<String, Map<String, dynamic>> imageData = {
      'images/shokuzai_daikon_white.webp': {
        'color': Color(0xFFedede8),
        'shape': '○'
      },
      'images/shokuzai_hourensou_green.webp': {
        'color': Color(0xFF020d00),
        'shape': '○'
      },
      'images/shokuzai_ikasumi_black.webp': {
        'color': Color(0xFF3b372b),
        'shape': '○'
      },
      'images/shokuzai_kona_gray.webp': {
        'color': Color(0xFF491d12),
        'shape': '○'
      },
      'images/shokuzai_korokke_blown.webp': {
        'color': Color(0xFF745127),
        'shape': '○'
      },
      'images/shokuzai_lemon_yellow.webp': {
        'color': Color(0xFFecd548),
        'shape': '⬜'
      },
      'images/shokuzai_orange_orange.webp': {
        'color': Color(0xFFe97200),
        'shape': '○'
      },
      'images/shokuzai_sauce_blown.webp': {
        'color': Color(0xFF491d12),
        'shape': '○'
      },
      'images/shokuzai_tomato_red.webp': {
        'color': Color(0xFF8e0002),
        'shape': '⬜'
      },
      'images/shokuzai_trevise_purple.webp': {
        'color': Color(0xFF9a4a86),
        'shape': '⬜'
      },
    };

    Color color = imageData[imagePath]!['color'];
    String shape = imageData[imagePath]!['shape'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LongPressDraggable<String>(
        data: imagePath,
        feedback: Opacity(opacity: 0.7, child: _buildShape(color, shape)),
        child: Image.asset(imagePath, width: 50, height: 50),
        childWhenDragging:
            Opacity(opacity: 0.7, child: _buildShape(color, shape)),
        onDragEnd: (details) {
          setState(() {
            items.add(DraggableItem(
                imagePath: imagePath,
                position: details.offset,
                scale: 1.0,
                color: color,
                shape: shape));
          });
        },
      ),
    );
  }

  Widget _buildShape(Color color, String shape) {
    if (shape == '○') {
      return CircleAvatar(backgroundColor: color, radius: 25);
    } else {
      return Container(width: 50, height: 50, color: color);
    }
  }

  Widget _getShapeIcon(DraggableItem item) {
    return _buildShape(item.color, item.shape);
  }

  void _selectItem(DraggableItem item) {
    setState(() {
      selectedItem = item;
    });
  }

  void _removeItem(DraggableItem item) {
    setState(() {
      items.remove(item);
      selectedItem = null;
    });
  }
}

class DraggableItem {
  final String imagePath;
  Offset position;
  double scale;
  final Color color;
  final String shape;
  double _previousScale; // 追加

  DraggableItem(
      {required this.imagePath,
      required this.position,
      required this.scale,
      required this.color,
      required this.shape,
      double? previousScale}) // 追加
      : _previousScale = previousScale ?? 1.0; // 追加
}
