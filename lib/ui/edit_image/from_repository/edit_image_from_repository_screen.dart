import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:edit_photo/constant/fonts/constant_font.dart';
import 'package:edit_photo/core/edit_type.dart';
import 'package:edit_photo/core/setup_locator.dart';
import 'package:edit_photo/core/setup_sp.dart';
import 'package:edit_photo/core/utils_image.dart';
import 'package:edit_photo/data/repository_response.dart';
import 'package:edit_photo/ui/edit_image/local_widget/discard_change_scrollablesheet.dart';
import 'package:edit_photo/ui/home_page.dart';
import 'package:edit_photo/ui/onboard/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:edit_photo/core/utils_string.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as transitionType;

class EditImageFromRepositoryScreen extends StatelessWidget {
  final ImageResponse imageResponse;
  const EditImageFromRepositoryScreen({required this.imageResponse, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditImageFromRepositoryLayout(imageResponse: imageResponse,);
  }
}

class EditImageFromRepositoryLayout extends StatefulWidget {
  final ImageResponse imageResponse;
  const EditImageFromRepositoryLayout({required this.imageResponse, Key? key}) : super(key: key);

  @override
  _EditImageFromRepositoryLayoutState createState() => _EditImageFromRepositoryLayoutState();
}

class _EditImageFromRepositoryLayoutState extends State<EditImageFromRepositoryLayout> {
  UtilsSaveImage utilsSaveImage = locator<UtilsSaveImage>();
  UtilsSharedPreferences utilsSp = locator<UtilsSharedPreferences>();
  UtilsEditImage utilsEditImage = locator<UtilsEditImage>();
  late File file;
  GlobalKey imageKey = GlobalKey();
  GlobalKey imageInWidgetKey = GlobalKey();
  double height = 0;
  double width = 0;
  bool isHorizontal = false;
  bool isVertical = false;
  bool isSquare = true;
  bool isImageCropped = false;

  double defaultBlur = 0;
  double tempBlur = 0;
  double valueBlur = 0;

  double defaultBrightness = 1;
  double tempBrightness = 1;
  double valueBrightness = 1;

  List<double> defaultPresets = UtilsEditImage().getPresetsNormal();
  List<double> tempPresets = UtilsEditImage().getPresetsNormal();
  List<double> valuePresets = UtilsEditImage().getPresetsNormal();

  RenderBox? imageSize;
  String editType = "";
  bool isEditingImage = false;
  bool backPressed = false;

  @override
  void initState() {
    super.initState();
    file = File(widget.imageResponse.imagePath);
    initEditValueImage();
    decodeImage();
    getSizeImageWidget();
  }

  initEditValueImage(){
    tempBlur = widget.imageResponse.blur??0;
    valueBlur = widget.imageResponse.blur??0;

    tempPresets = widget.imageResponse.presets??UtilsEditImage().getPresetsNormal();
    valuePresets = widget.imageResponse.presets??UtilsEditImage().getPresetsNormal();

    tempBrightness = widget.imageResponse.brightness??1;
    valueBrightness = widget.imageResponse.brightness??1;
  }

  decodeImage()async{
   var decodedImage =  await decodeImageFromList(file.readAsBytesSync());
   if(decodedImage.width > decodedImage.height){
     isHorizontal = true;
     isVertical = false;
     isSquare = false;
   }else if(decodedImage.height > decodedImage.width){
     isVertical = true;
     isHorizontal = false;
     isSquare = false;
   }else{
     isSquare = true;
     isHorizontal = false;
     isVertical = false;
   }
  }

  Future<RenderBox> getSizeImageWidget()async{
    final keyContext = imageKey.currentContext;
    final box = keyContext?.findRenderObject() as RenderBox;
    imageSize = box;
    return box;
  }

  Future<bool> onWillPop()async{
    if(isEditingImage){
      if(editType==EditType.blur){
        valueBlur = tempBlur;
      }else if(editType==EditType.brightness){
        valueBrightness = tempBrightness;
      }else if(editType==EditType.presets){
        valuePresets = tempPresets;
      }
      isEditingImage = false;
      setState(() {});
      return false;
    }else if(valueBlur!=defaultBlur || valuePresets!=defaultPresets || valueBrightness!=defaultBrightness || isImageCropped==true){
      showModalBottomSheet(context: context, builder: (context) =>
          DiscardChangeScrollableSheet(
            discardChangeOnPressed: (){
              backPressed = true;
              Get.back();
              Get.back();
            },
            cancelOnPressed: (){
              backPressed = false;
              Get.back();
            },
          )
      );
      return false;
    }else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(height: MediaQuery.of(context).padding.top,),
            Visibility(visible: !isEditingImage,child: Container(color: Colors.black, padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),child: buildAppbar())),
            Expanded(child: Center(child: buildLayoutEditImage(),)),
            Visibility(
              visible: !isEditingImage,
              child: Container(color: Colors.black, padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 8),child: buildFeatureForAdjustEdit(),),
            ),
            Visibility(
              visible: isEditingImage,
              child: Column(
                children: [
                  Container(
                      color: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: editType == EditType.blur ? buildSliderBlur() : editType == EditType.brightness ? buildSliderBrightness() : editType==EditType.presets ? buildSelectorPresets() : Container()
                  ),
                  Container(color: Colors.black, padding: EdgeInsets.symmetric(horizontal: 8),child: buildSaveCancelEdit()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppbar() =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.close_rounded, color: Colors.white,)),
        TextButton(onPressed: ()async{
          saveImage();
        }, child: Text("SAVE", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.white),))
      ],
    );


  buildLayoutEditImage(){
    return Container(
      child: Stack(
        key: imageInWidgetKey,
        children: [
          ColorFiltered(
              colorFilter: ColorFilter.matrix(UtilsEditImage().getMatrixBrightness(brightness: valueBrightness)),
              child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(valuePresets),
                  child: Image.file(file, key: imageKey, fit: isHorizontal ? BoxFit.fitWidth : isVertical ? BoxFit.fitHeight : BoxFit.cover,)
              )
          ),
          StreamBuilder(
            stream: Stream.fromFuture(getSizeImageWidget()),
            builder: (context, snapshot){
              if(imageSize!=null){
                return ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: valueBlur, sigmaX: valueBlur),
                    child: Container(
                      color: Colors.black.withOpacity(0.0), height: imageSize?.size.height, width: imageSize?.size.width,
                    ),
                  ),
                );
              }else{
                getSizeImageWidget();
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  buildSliderBlur(){
    return Slider(
        max: 10,
        min: 0,
        value: valueBlur,
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
        onChanged: (value){
          valueBlur = value;
          setState(() {});
        }
        );
  }

  buildSliderBrightness(){
    return Slider(
        value: valueBrightness,
        min: 0.5,
        max: 1.5,
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
        onChanged: (value){
          valueBrightness = value;
          setState(() {});
        }
    );
  }

  buildSelectorPresets(){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            GestureDetector(
                onTap: (){
                  setState(() {
                    valuePresets = UtilsEditImage().getPresetsNormal();
                  });
                },
                child: layoutPresets(preset: UtilsEditImage().getPresetsNormal(), namePreset: "Normal")
            ),
            SizedBox(width: 16,),
            GestureDetector(
                onTap: (){
                  setState(() {
                    valuePresets = UtilsEditImage().getPresetsBW1();
                  });
                },
                child: layoutPresets(preset: UtilsEditImage().getPresetsBW1(), namePreset: "BW1")
            ),
            SizedBox(width: 16,),
            GestureDetector(
              onTap: (){
                setState(() {
                  valuePresets = UtilsEditImage().getPresetsR1();
                });
              },
              child: layoutPresets(preset: UtilsEditImage().getPresetsR1(), namePreset: "R1"),
            ),
            SizedBox(width: 16,),
            GestureDetector(
              onTap: (){
                setState(() {
                  valuePresets = UtilsEditImage().getPresetsG1();
                });
              },
              child: layoutPresets(preset: UtilsEditImage().getPresetsG1(), namePreset: "G1"),
            ),
            SizedBox(width: 16,),
            GestureDetector(
              onTap: (){
                setState(() {
                  valuePresets = UtilsEditImage().getPresetsB1();
                });
              },
              child: layoutPresets(preset: UtilsEditImage().getPresetsB1(), namePreset: "B1"),
            ),
          ],
        ),
      ),
    );
  }

  Widget layoutPresets({required List<double> preset, required String namePreset}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.matrix(preset),
          child: Container(height: 50, width: 50, decoration: BoxDecoration(border: Border.all(color: Colors.white),color: Colors.white, image: DecorationImage(image: FileImage(file), fit: BoxFit.cover)),),
        ),
        SizedBox(height: 8,),
        Text("$namePreset", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.white, fontSize: 13),)
      ],
    );
  }

  buildSaveCancelEdit(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(onPressed: (){
          if(editType==EditType.blur){
            setState(() {
              valueBlur = tempBlur;
              isEditingImage = false;
            });
          }else if(editType==EditType.brightness){
            setState(() {
              valueBrightness = tempBrightness;
              isEditingImage = false;
            });
          }else if(editType==EditType.presets){
            setState(() {
              valuePresets = tempPresets;
              isEditingImage = false;
            });
          }
        }, icon: Icon(Icons.close, color: Colors.white,)),
        Text("$editType", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.white),),
        IconButton(onPressed: (){
          if(editType==EditType.blur){
            setState(() {
              tempBlur = valueBlur;
              isEditingImage = false;
            });
          }else if(editType==EditType.brightness){
            setState(() {
              tempBrightness = valueBrightness;
              isEditingImage = false;
            });
          }else if(editType==EditType.presets){
            setState(() {
              tempPresets = valuePresets;
              isEditingImage = false;
            });
          }
        }, icon: Icon(Icons.check, color: Colors.white,)),
      ],
    );
  }

  buildFeatureForAdjustEdit(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: (){
              setState(() {
                isEditingImage = true;
                editType = EditType.presets;
              });
            },
            child: Padding(padding: EdgeInsets.all(16), child: Text("Presets", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.white, fontSize: 14),))
        ),
        GestureDetector(
            onTap: (){
              setState(() {
                isEditingImage = true;
                editType = EditType.blur;
              });
            },
            child: Padding(padding: EdgeInsets.all(16), child: Text("Blur", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.white, fontSize: 14),))
        ),
        GestureDetector(
            onTap: (){
              setState(() {
                isEditingImage = true;
                editType = EditType.brightness;
              });
            },
            child: Padding(padding: EdgeInsets.all(16), child: Text("Brightness", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.white, fontSize: 14),),)
        ),
        GestureDetector(
            onTap: ()async{
              File? croppedFile = await ImageCropper.cropImage(
                  sourcePath: file.path,
                  androidUiSettings: AndroidUiSettings(
                    hideBottomControls: true,
                    backgroundColor: Colors.black,
                    toolbarColor: Colors.black,
                    toolbarWidgetColor: Colors.white,
                    showCropGrid: false,
                    lockAspectRatio: false,
                    toolbarTitle: "Crop Photo",
                  ),
                  aspectRatioPresets: [
                    CropAspectRatioPreset.square
                  ]
              );
              if(croppedFile!=null){
                isImageCropped = true;
                file = croppedFile;
              }
              setState(() {});
              Future.delayed(Duration(milliseconds: 100), (){
                setState(() {});
              });
            },
            child: Padding(padding: EdgeInsets.all(16), child: Text("Crop", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.white, fontSize: 14),),)
        ),
      ]
    );
  }

  Future saveImage()async{
    // File image = File(file.path);
    // String fileName = "".getRandomString(10);
    // Directory pictureDir = await utilsSaveImage.getDirPath();
    // var imagePath = "${pictureDir.path}$fileName.png";
    // await image.copy(imagePath);
    saveImageToSp(file.path);
  }

  Future saveImageToSp(String imagePath)async{
    var data = await utilsSp.getObject("LOCAL_PATH");
    if(data==null){
      print("SAVE NEW LOCAL_PATH");
      List<String> list = [imagePath];
      List<ImageResponse> listImageResponse = [
        ImageResponse(imagePath, blur: valueBlur, brightness: valueBrightness, presets: valuePresets),
      ];
      RepositoryResponse repositoryResponse = RepositoryResponse(listRepository: list, listImageResponse: listImageResponse);
      String jsonEncodeAllRepositoryResponse = jsonEncode(repositoryResponse);
      await utilsSp.setObject("LOCAL_PATH", jsonEncodeAllRepositoryResponse);
    }else{
      var stringJsonAllRepositoryResponse = jsonDecode(data);
      RepositoryResponse repositoryResponse = RepositoryResponse.fromJson(jsonDecode(stringJsonAllRepositoryResponse));
      repositoryResponse.listRepository.add(imagePath);
      repositoryResponse.listImageResponse.removeWhere((element) => element.imagePath==imagePath);
      repositoryResponse.listImageResponse.add(ImageResponse(imagePath, blur: valueBlur, brightness: valueBrightness, presets: valuePresets));
      String jsonEncodeAllRepositoryResponse = jsonEncode(repositoryResponse);
      await utilsSp.setObject("LOCAL_PATH", jsonEncodeAllRepositoryResponse);
    }
    Future.delayed(Duration(seconds: 1), (){
      Get.offAll(OnBoardScreen(), transition: transitionType.Transition.fadeIn);
      Get.to(HomePageScreen(indexTab: 1,), transition: transitionType.Transition.downToUp);
    });
  }
}

