import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  final VoidCallback onBackPressed;
  final VoidCallback onSavePressed;

  CustomAppBar({
    required this.onBackPressed,
    required this.onSavePressed,
  }) : super(
          backgroundColor: Colors.transparent,
          elevation: 0, // 影を消す
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: onBackPressed,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: onSavePressed,
            ),
          ],
        );
}
