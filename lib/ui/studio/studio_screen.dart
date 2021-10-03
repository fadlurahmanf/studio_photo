import 'dart:io';
import 'package:edit_photo/constant/assets/constant_asset.dart';
import 'package:edit_photo/constant/color/constant_color.dart';
import 'package:edit_photo/constant/fonts/constant_font.dart';
import 'package:edit_photo/core/setup_locator.dart';
import 'package:edit_photo/data/gallery_entity.dart';
import 'package:edit_photo/ui/camera_view/camera_view_screen.dart';
import 'package:edit_photo/ui/image_view/image_view_screen.dart';
import 'package:edit_photo/ui/onboard/opensetting_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as transitionType;

class StudioScreen extends StatelessWidget {
  const StudioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StudioLayout();
  }
}

class StudioLayout extends StatefulWidget {
  const StudioLayout({Key? key}) : super(key: key);

  @override
  _StudioLayoutState createState() => _StudioLayoutState();
}

class _StudioLayoutState extends State<StudioLayout> {
  bool isOverlayShown = false;
  OverlayState? overlayState;
  OverlayEntry? overlayEntry;
  GalleryEntity galleryEntity = locator<GalleryEntity>();
  String? albumIndexName;
  int indexAlbum = 0;

  shownOrCloseOverlay(){
    if(isOverlayShown){
      isOverlayShown = false;
      closeOverlay();
    }else{
      isOverlayShown = true;
      initOverlay();
    }
  }

  @override
  void initState() {
    super.initState();
    albumIndexName = galleryEntity.listAssetPathEntity?.first.name;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(color: ConstantColor.primaryBlack, child: buildAppbar(),),
          Expanded(child: buildContentGallery()),
          // Expanded(child: buildContentGallery2()),
        ],
      ),
    );
  }

  Widget buildAppbar()=> Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: (){
          shownOrCloseOverlay();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(albumIndexName??galleryEntity.listAssetPathEntity?.first.name??"Recent", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.white),),
              SizedBox(width: 7,),
              Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white,)
            ],
          ),
        ),
      ),
    ],
  );

  initOverlay()async{
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context){
          return Positioned(
            top: 90,
            child: Material(
              child: Container(
                height: 400,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(-2, 2), blurRadius: 4, spreadRadius: 1)]),
                width: MediaQuery.of(context).size.width,
                child: buildContentOverlay(),
              ),
            ),
          );
        }
    );
    overlayState?.insert(overlayEntry!);
  }

  closeOverlay()async{
    overlayEntry?.remove();
  }

  Widget buildContentOverlay() => ListView.builder(
      padding: EdgeInsets.zero,
      physics: BouncingScrollPhysics(),
      itemCount: galleryEntity.listAssetPathEntity?.length,
      itemBuilder: (context, position){
        return GestureDetector(
          onTap: (){
            albumIndexName = galleryEntity.listAssetPathEntity?[position].name;
            indexAlbum = position;
            setState(() {});
            closeOverlay();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: Text("${galleryEntity.listAssetPathEntity?[position].name}", style: TextStyle(fontFamily: ConstantFont.metropolis),)),
                Icon(Icons.keyboard_arrow_down, color: ConstantColor.primaryBlack,)
              ],
            ),
          ),
        );
      }
  );

  Widget buildContentGallery() => FutureBuilder(
    future: galleryEntity.listAssetPathEntity?[indexAlbum].assetList,
    builder: (context, snapshot){
      if(snapshot.hasData && snapshot.data!=null){
        List<AssetEntity> listAssetEntity = snapshot.data as List<AssetEntity>;
        PhotoCachingManager().requestCacheAssets(assets: listAssetEntity);
        return GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                childAspectRatio: 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5
            ),
            itemCount: listAssetEntity.length,
            itemBuilder: (context, position){
              switch (position){
                case 0 :
                  return GestureDetector(onTap: ()async{
                    bool isAllGranted = false;
                    Map<Permission, PermissionStatus> statuses = await [
                      Permission.camera,
                      Permission.microphone
                    ].request();
                    for(var number in statuses.values){
                      if(!number.isGranted){
                        isAllGranted = false;
                        break;
                      }else{
                        isAllGranted = true;
                      }
                    }
                    if(!isAllGranted){
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context, builder: (context) => OpenSettingBottomSheet(contentText: "THIS APPS NEEDS REQUEST CAMERA AND MICROPHONE PERMISSION",)
                      );
                    }else{
                      Get.to(CameraViewScreen());
                    }
                    },
                      child: Container(decoration: BoxDecoration(color: Colors.white, image: DecorationImage(image: AssetImage(ConstantAsset.ic_camera,), scale: 10)),)
                  );
                default :
                  return FutureBuilder(
                    future: listAssetEntity[position].file,
                    builder: (context, snapshotFile){
                      if(snapshotFile.hasData && snapshotFile.data!=null){
                        File file = snapshotFile.data as File;
                        return GestureDetector(
                            onTap: (){
                              Get.to(ImageViewScreen(file: file,), transition: transitionType.Transition.downToUp);
                            },
                            child: Container(child: Image.file(File(file.path), fit: BoxFit.cover,),),
                        );
                      }else{
                        return Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.white, child: Container(height: 50, width: 50, color: Colors.black,),);
                      }
                    },
                  );
              }
            }
        );
      }else{
        return Center(child: SizedBox(height: 25,width: 25,child: CircularProgressIndicator(color: ConstantColor.primaryBlack,)),);
      }
    },
  );
}

