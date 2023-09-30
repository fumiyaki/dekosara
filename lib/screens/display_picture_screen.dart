import 'package:flutter/material.dart';
import 'dart:io';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 画像を背景として配置
            Positioned.fill(
              child: Image.file(
                File(imagePath),
                fit: BoxFit.fill,
              ),
            ),

            // カスタムAppBar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBar(
                onBackPressed: () {
                  Navigator.of(context).pop();
                },
                onSavePressed: () {
                  // 保存処理をこちらに追加
                },
              ),
            ),

            // BottomNavBar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}
