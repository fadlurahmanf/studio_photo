import 'package:camera/camera.dart';
import 'package:edit_photo/main.dart';
import 'package:flutter/material.dart';

class CameraViewScreen extends StatelessWidget {
  const CameraViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CameraViewLayout();
  }
}

class CameraViewLayout extends StatefulWidget {
  const CameraViewLayout({Key? key}) : super(key: key);

  @override
  _CameraViewLayoutState createState() => _CameraViewLayoutState();
}

class _CameraViewLayoutState extends State<CameraViewLayout> {
  late CameraController cameraController;

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((value){
      if(!mounted){
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !cameraController.value.isInitialized ? Container() : buildLayout(),
    );
  }

  Widget buildLayout() => Column(
    children: [
      CameraPreview(cameraController),
      ElevatedButton(onPressed: (){}, child: Text("data"),)
    ],
  );
}

