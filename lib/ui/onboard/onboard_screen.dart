
import 'package:edit_photo/constant/fonts/constant_font.dart';
import 'package:edit_photo/core/setup_locator.dart';
import 'package:edit_photo/data/gallery_entity.dart';
import 'package:edit_photo/ui/home_page.dart';
import 'package:edit_photo/ui/onboard/opensetting_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as transitionType;

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnBoardLayout();
  }
}

class OnBoardLayout extends StatefulWidget {
  const OnBoardLayout({Key? key}) : super(key: key);

  @override
  _OnBoardLayoutState createState() => _OnBoardLayoutState();
}

class _OnBoardLayoutState extends State<OnBoardLayout> {
  bool isLoading = false;
  GalleryEntity galleryEntity = locator<GalleryEntity>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("WELCOME TO STUDIO PHOTO", style: TextStyle(fontFamily: ConstantFont.metropolis, fontWeight: FontWeight.w100),),
            SizedBox(height: 5,),
            Text("by fadlurahmanf", style: TextStyle(fontFamily: ConstantFont.metropolis, fontWeight: FontWeight.bold),),
            SizedBox(height: 12,),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                  onPressed: ()async{
                    isLoading = true;
                    setState(() {});
                    var result = await PhotoManager.requestPermissionExtend();
                    if(result.isAuth){
                      List<AssetPathEntity> listAssetPathEntity = await PhotoManager.getAssetPathList(type: RequestType.image);
                      galleryEntity.listAssetPathEntity = listAssetPathEntity;
                      isLoading = false;
                      setState(() {});
                      if(galleryEntity.listAssetPathEntity!=null) Get.to(HomePageScreen(), transition: transitionType.Transition.fadeIn);
                    }
                    else{
                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => OpenSettingBottomSheet(contentText: "THIS APPS NEEDS REQUEST STORAGE PERMISSION",)
                      );
                    }
                  },
                  child: isLoading ?  SizedBox(width: 20, height: 20,child: CircularProgressIndicator(color: Colors.white,)) : Text("HOME PAGE"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12))
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

