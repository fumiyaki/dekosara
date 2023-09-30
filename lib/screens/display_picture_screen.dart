import 'dart:io';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String?
      imagePath; // Added to accept the path of the image from the previous screen

  DisplayPictureScreen({this.imagePath});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  List<DraggableItem> items = [];
  DraggableItem? selectedItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem = null;
        });
      },
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      child: Scaffold(
        body: Stack(
          children: [
            // Place image as the background
            Positioned.fill(
              child: widget.imagePath != null
                  ? Image.file(
                      File(widget.imagePath!),
                      fit: BoxFit.fill,
                    )
                  : Container(), // Show an empty container if imagePath is null
            ),
            ...items.map((item) {
              bool isSelected = selectedItem == item;
              double opacity = isSelected ? 0.7 : 1.0;
              return Positioned(
                left: item.position.dx,
                top: item.position.dy,
                child: Transform.scale(
                  scale: item.scale,
                  child: Opacity(
                    opacity: opacity,
                    child: isSelected
                        ? Draggable<Color>(
                            data: item.color,
                            feedback: Transform.scale(
                              scale: item.scale,
                              child: Opacity(
                                opacity: 0.7,
                                child: Icon(Icons.circle,
                                    color: item.color, size: 50.0),
                              ),
                            ),
                            childWhenDragging: Container(),
                            child: GestureDetector(
                              onLongPress: () => _removeItem(item),
                              onTap: () => _selectItem(item),
                              child: Icon(Icons.circle,
                                  color: item.color, size: 50.0),
                            ),
                            onDraggableCanceled: (velocity, offset) {
                              setState(() {
                                item.position = offset;
                              });
                            },
                          )
                        : GestureDetector(
                            onLongPress: () => _removeItem(item),
                            onTap: () => _selectItem(item),
                            child: Icon(Icons.circle,
                                color: item.color, size: 50.0),
                          ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
        bottomNavigationBar: _buildBottomAppBar(),
      ),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // Make sure the Column doesn't take more space than its children
        children: [
          // Bottom Bar A
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: Colors.primaries
                .take(4)
                .map((color) => _buildDraggableIcon(color))
                .toList(),
          ),
          // Bottom Bar B
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('images/syokuzai_main.webp',
                    width: 50, height: 50), // Updated path
                Image.asset('images/powderandsouse.webp',
                    width: 50, height: 50), // Updated path
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectItem(DraggableItem item) {
    setState(() {
      selectedItem = item;
    });
  }

  void _onScaleStart(ScaleStartDetails details) {
    if (selectedItem != null) {
      selectedItem!.initialScale = selectedItem!.scale;
    }
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (selectedItem != null) {
      setState(() {
        selectedItem!.scale = selectedItem!.initialScale * details.scale;
      });
    }
  }

  Widget _buildDraggableIcon(Color color) {
    return Expanded(
      child: LongPressDraggable<Color>(
        delay: Duration(milliseconds: 300),
        data: color,
        feedback: Icon(Icons.circle, color: color, size: 50.0),
        child: Icon(Icons.circle, color: color, size: 50.0),
        onDragEnd: (details) {
          setState(() {
            items.add(DraggableItem(
                color: color, position: details.offset, scale: 1.0));
          });
        },
      ),
    );
  }

  void _removeItem(DraggableItem item) {
    setState(() {
      items.remove(item);
      selectedItem = null;
    });
  }
}

class DraggableItem {
  Color color;
  Offset position;
  double scale;
  double initialScale = 1.0;

  DraggableItem(
      {required this.color, required this.position, required this.scale});
}
