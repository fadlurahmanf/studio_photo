import 'dart:io';
import 'package:edit_photo/constant/fonts/constant_font.dart';
import 'package:edit_photo/core/setup_locator.dart';
import 'package:edit_photo/core/setup_sp.dart';
import 'package:edit_photo/core/utils_image.dart';
import 'package:edit_photo/ui/edit_image/edit_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edit_photo/core/utils_string.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as transitionType;
import 'package:social_share/social_share.dart';

class ImageViewScreen extends StatelessWidget {
  final File file;
  const ImageViewScreen({required this.file, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageViewLayout(file: file,);
  }
}

class ImageViewLayout extends StatefulWidget {
  final File file;
  const ImageViewLayout({required this.file, Key? key}) : super(key: key);

  @override
  _ImageViewLayoutState createState() => _ImageViewLayoutState();
}

class _ImageViewLayoutState extends State<ImageViewLayout> {
  UtilsSharedPreferences utilsSp = locator<UtilsSharedPreferences>();
  UtilsSaveImage utilsImage = locator<UtilsSaveImage>();
  late FileStat fileStat;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(height: MediaQuery.of(context).padding.top, color: Colors.black,),
          Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.file(File(widget.file.path)),
                    SizedBox(height: 16,),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FutureBuilder(
                        future: widget.file.stat(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            FileStat stat = snapshot.data as FileStat;
                            fileStat = stat;
                            return Text(stat.modified.toString().toDate(), style: TextStyle(fontFamily: ConstantFont.metropolis, fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),);
                          }else{
                            return Text("");
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 32,),
                  ],
                ),
              )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildBottomBar(),
          )
        ],
      ),
    );
  }

  Widget buildAppbar() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(onTap: (){Get.back();},child: Icon(Icons.arrow_back_ios_outlined, color: Colors.white, size: 20,),),
      GestureDetector(onTap: ()async{
        // File image = File(widget.file.path);
        // String fileName = getRandomString(10);
        // Directory pictureDir = await utilsImage.getDirPath();
        // var imagePath = "${pictureDir.path}$fileName.png";
        // await image.copy(imagePath);
        // saveImagePath(imagePath);
      },child: Text("DONE", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.white),),),
    ],
  );

  Widget buildBottomBar() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Padding(padding: const EdgeInsets.all(16.0), child: Text("CLOSE", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.black, fontSize: 14),),),
      ),
      GestureDetector(
        onTap: (){
          Get.to(EditImageScreen(file: widget.file, fileStat: fileStat,), transition: transitionType.Transition.downToUp);
        },
        child: Padding(padding: const EdgeInsets.all(16.0), child: Text("EDIT", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.black, fontSize: 14),),),
      ),
      GestureDetector(
        onTap: ()async{
          await SocialShare.shareInstagramStory(widget.file.path, backgroundBottomColor: "#ffffff", backgroundTopColor: "#ffffff");
        },
        child: Padding(padding: const EdgeInsets.all(16.0), child: Text("SHARE", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.black, fontSize: 14),),),
      ),
    ],
  );

  // void saveImagePath(String imagePath)async{
  //   var data = await utilsSp.getObject("LOCAL_PATH");
  //   if(data==null){
  //     print("SAVE NEW LOCAL_PATH");
  //     List<String> list = [imagePath];
  //     RepositoryResponse repositoryResponse = RepositoryResponse(listRepository: list);
  //     String jsonEncodeAllRepositoryResponse = jsonEncode(repositoryResponse);
  //     await utilsSp.setObject("LOCAL_PATH", jsonEncodeAllRepositoryResponse);
  //   }else{
  //     var stringJsonAllRepositoryResponse = jsonDecode(data);
  //     RepositoryResponse repositoryResponse = RepositoryResponse.fromJson(jsonDecode(stringJsonAllRepositoryResponse));
  //     repositoryResponse.listRepository.add(imagePath);
  //     String jsonEncodeAllRepositoryResponse = jsonEncode(repositoryResponse);
  //     await utilsSp.setObject("LOCAL_PATH", jsonEncodeAllRepositoryResponse);
  //   }
  // }
}

