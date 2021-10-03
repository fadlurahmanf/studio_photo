import 'package:edit_photo/core/setup_sp.dart';
import 'package:edit_photo/core/utils_image.dart';
import 'package:edit_photo/data/gallery_entity.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

class LocatorModule{
  static void init(){
    locator.registerSingleton(GalleryEntity());
    locator.registerFactory(() => UtilsSharedPreferences());
    locator.registerFactory(() => UtilsSaveImage());
    locator.registerSingleton(UtilsEditImage());
  }
}