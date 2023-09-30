import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  // アプリの初期化処理
  WidgetsFlutterBinding.ensureInitialized();
  
  // 利用可能なカメラのリストを取得
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TakePictureScreen(camera: camera),
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  TakePictureScreen({required this.camera});

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  // カメラコントローラの初期化
  void _initializeCameraController() {
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<void> _takePhoto() async {
    // カメラが初期化されているかを確認
    if (!_controller.value.isInitialized) {
      print("Controller is not initialized.");
      return;
    }

    // 写真を撮影
    final XFile? file = await _controller.takePicture();

    // 成功したら、編集ページに遷移
    if (file != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPictureScreen(imagePath: file.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller), // カメラのプレビュー表示
          Positioned(
            bottom: 20,
            right: 60,
            child: FloatingActionButton(
              child: Icon(Icons.camera),
              onPressed: _takePhoto, // 写真撮影処理
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // カメラコントローラの解放
    super.dispose();
  }
}

class EditPictureScreen extends StatelessWidget {
  final String imagePath;

  EditPictureScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Picture")),
      body: Image.asset(imagePath), // 撮影した画像を表示
      // TODO: 画像編集の機能やUIを追加
    );
  }
}
