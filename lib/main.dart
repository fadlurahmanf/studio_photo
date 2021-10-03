import 'package:camera/camera.dart';
import 'package:edit_photo/core/setup_locator.dart';
import 'package:edit_photo/ui/onboard/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

late List<CameraDescription> cameras;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  LocatorModule.init();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'STUDIO PHOTO BY FADLURAHMANF',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OnBoardScreen(),
    );
  }
}
