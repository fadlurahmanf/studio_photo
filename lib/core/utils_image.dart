import 'dart:io';
import 'package:path_provider/path_provider.dart' as pathProvider;

class UtilsSaveImage{
  Future<Directory> getDirPath()async{
    String pictureDirName = "STUDIOPHOTO";
    Directory localDir = await pathProvider.getApplicationDocumentsDirectory();
    Directory picturesDir = Directory(localDir.path+"/"+pictureDirName+"/");
    if(!picturesDir.existsSync()){
      await picturesDir.create(recursive: true);
      return picturesDir;
    }else{
      return picturesDir;
    }
  }
  Future<Directory> getExternalDirectory()async{
    Directory? appDir = await pathProvider.getExternalStorageDirectory();
    String picturesDirName = "STUDIOPHOTO";
    List<String>? externalPathList = appDir?.path.split('/');
    int? posOfAndroidDir = externalPathList?.indexOf('Android');
    String rootPath = externalPathList!.sublist(0, posOfAndroidDir).join('/');
    rootPath+="/";
    Directory picturesDir = Directory(rootPath+picturesDirName+"/");
    print(picturesDir.path);
    if (!picturesDir.existsSync()) {
      await picturesDir.create(recursive: true);
      return picturesDir;
    } else {
      return picturesDir;
    }
  }
}

class UtilsEditImage{
  List<double> getMatrixBrightness({required double brightness}){
    double valueBrightness = brightness;
    List<double> list = <double>[
      valueBrightness, 0, 0, 0, 0,
      0, valueBrightness, 0, 0, 0,
      0, 0, valueBrightness, 0, 0,
      0, 0, 0, valueBrightness, 0,
    ];
    return list;
  }

  List<double> getPresetsNormal(){
    List<double> list = <double>[
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0,
    ];
    return list;
  }

  List<double> getPresetsBW1(){
    List<double> list = <double>[
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0,      0,      0,      1, 0,
    ];
    return list;
  }

  List<double> getPresetsR1(){
    List<double> list = <double>[
      2, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0,
    ];
    return list;
  }

  List<double> getPresetsG1(){
    List<double> list = <double>[
      1, 0, 0, 0, 0,
      0, 2, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0,
    ];
    return list;
  }

  List<double> getPresetsB1(){
    List<double> list = <double>[
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 2, 0, 0,
      0, 0, 0, 1, 0,
    ];
    return list;
  }
}