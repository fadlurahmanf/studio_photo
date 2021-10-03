import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:edit_photo/constant/fonts/constant_font.dart';
import 'package:edit_photo/core/setup_locator.dart';
import 'package:edit_photo/core/setup_sp.dart';
import 'package:edit_photo/core/utils_image.dart';
import 'package:edit_photo/ui/dummyscreen.dart';
import 'package:edit_photo/ui/edit_image/from_repository/edit_image_from_repository_screen.dart';
import 'package:edit_photo/ui/repository/bloc/repository_bloc.dart';
import 'package:edit_photo/ui/repository/bloc/repository_event.dart';
import 'package:edit_photo/ui/repository/bloc/repository_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:social_share/social_share.dart';
import 'package:edit_photo/core/utils_string.dart';

class RepositoryScreen extends StatelessWidget {
  const RepositoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>RepositoryBloc()..add(RepositoryGetRepositoryImage()))
      ],
      child: RepositoryLayout(),
    );
  }
}

class RepositoryLayout extends StatefulWidget {
  const RepositoryLayout({Key? key}) : super(key: key);

  @override
  _RepositoryLayoutState createState() => _RepositoryLayoutState();
}

class _RepositoryLayoutState extends State<RepositoryLayout> {
  UtilsSharedPreferences utilsSp = locator<UtilsSharedPreferences>();
  late List<String> listRepository;

  initDataFromSp(){
  }

  @override
  void initState() {
    super.initState();
  }

  // GlobalKey keyImage = GlobalKey();
  Map<String, GlobalKey> mapKeyImage = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<RepositoryBloc, RepositoryState>(
                builder: (context, state){
                  if(state is RepositoryImageLoaded){
                    return GridView.builder(
                      padding: EdgeInsets.only(top: 10),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          childAspectRatio: 1,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5
                      ),
                      itemCount: state.listPhoto.length,
                      itemBuilder: (context, position){
                        mapKeyImage[state.listPhoto[position].imagePath] = GlobalKey();
                        return GestureDetector(
                          onTap: (){
                            showDialog(
                                context: context,
                                builder: (_) => RepositoryDialog(
                                  onPressedEditImage: (){
                                    Get.back();
                                    Get.to(EditImageFromRepositoryScreen(imageResponse: state.listPhoto[position]));
                                  },
                                  onPressedSaveImage: (){
                                    Get.back();
                                    var snackbar = SnackBar(
                                        content: Text("SAVE IMAGE TO GALLERY", textAlign: TextAlign.center, style: TextStyle(fontFamily: ConstantFont.metropolis),),
                                        duration: Duration(seconds: 2),
                                    );
                                    Scaffold.of(context).showSnackBar(snackbar);
                                  },
                                  onPressedSharedImage: ()async{
                                    Get.back();
                                    String imageCopyPath = "";
                                    String randomName = "".getRandomString(10);
                                    await UtilsSaveImage().getDirPath().then((value) => imageCopyPath = "${value.path}$randomName.png");
                                    RenderRepaintBoundary boundary = mapKeyImage[state.listPhoto[position].imagePath]?.currentContext?.findRenderObject() as RenderRepaintBoundary;
                                    ui.Image image = await boundary.toImage(pixelRatio: 10);
                                    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                                    Uint8List? pngBytes = byteData?.buffer.asUint8List();
                                    File fileTempImage = await File(imageCopyPath).create(recursive: true);
                                    fileTempImage.writeAsBytesSync(pngBytes!);
                                    await SocialShare.shareInstagramStory(fileTempImage.path);
                                  },
                                ),
                            );
                          },
                          child: RepaintBoundary(
                            key: mapKeyImage[state.listPhoto[position].imagePath],
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.matrix(UtilsEditImage().getMatrixBrightness(brightness: state.listPhoto[position].brightness??1)),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.matrix(state.listPhoto[position].presets??UtilsEditImage().getPresetsNormal()),
                                    child: Image.file(File(state.listPhoto[position].imagePath)),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.zero,
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaY: state.listPhoto[position].blur??0, sigmaX: state.listPhoto[position].blur??0),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.0)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }else{
                    return Center(child: Text("Empty", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.black),));
                  }
                }
            ),
          )
        ],
      ),
    );
  }
}

class RepositoryDialog extends StatelessWidget {
  final VoidCallback onPressedEditImage;
  final VoidCallback onPressedSharedImage;
  final VoidCallback onPressedSaveImage;
  const RepositoryDialog({required this.onPressedEditImage, required this.onPressedSaveImage, required this.onPressedSharedImage, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          direction: Axis.horizontal,
          verticalDirection: VerticalDirection.down,
          runAlignment: WrapAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: onPressedEditImage, child: Center(child: Text("EDIT IMAGE", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.white),)),
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black)
                ),
            ),
            ElevatedButton(
              onPressed: onPressedSharedImage, child: Center(child: Text("SHARE IMAGE", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.black),)),
              style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white)
              ),
            ),
            ElevatedButton(
              onPressed: onPressedSaveImage, child: Center(child: Text("SAVE IMAGE TO GALLERY", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.black),)),
              style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white)
              ),
            ),
          ],
        ),
      ),
    );
  }
}


