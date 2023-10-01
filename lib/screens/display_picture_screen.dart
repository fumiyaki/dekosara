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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem = null;
        });
      },
      onScaleStart: (ScaleStartDetails details) {
        _previousScale = _scale;
        setState(() {});
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        _scale = _previousScale * details.scale;
        setState(() {
          if (selectedItem != null) {
            selectedItem!.scale = _scale;
          }
        });
      },
      child: Scaffold(
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
                      feedback: Opacity(
                        opacity: 0.7,
                        child: _getShapeIcon(item),
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

  Widget _buildShape(Color color, String shape) {
    if (shape == 'circle') {
      return CircleAvatar(backgroundColor: color, radius: 25);
    } else {
      return Container(width: 50, height: 50, color: color);
    }
  }

  Widget _buildDraggableImage(String imagePath) {
    var colors = [
      Colors.white,
      Colors.green,
      Colors.black,
      Colors.grey,
      Colors.brown,
      Colors.yellow,
      Colors.orange,
      Colors.brown,
      Colors.red,
      Colors.purple
    ];
    var random = Random();
    Color randomColor = colors[random.nextInt(colors.length)];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LongPressDraggable<String>(
        data: imagePath,
        feedback:
            Opacity(opacity: 0.7, child: _buildShape(randomColor, 'rectangle')),
        child: Image.asset(imagePath, width: 50, height: 50),
        childWhenDragging:
            Opacity(opacity: 0.7, child: _buildShape(randomColor, 'rectangle')),
        onDragEnd: (details) {
          setState(() {
            items.add(DraggableItem(
                imagePath: imagePath,
                position: details.offset,
                scale: 1.0,
                color: randomColor,
                shape: 'rectangle'));
          });
        },
      ),
    );
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

  DraggableItem(
      {required this.imagePath,
      required this.position,
      required this.scale,
      required this.color,
      required this.shape});
}
