import 'package:edit_photo/constant/color/constant_color.dart';
import 'package:edit_photo/constant/fonts/constant_font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class OpenSettingBottomSheet extends StatelessWidget {
  final String contentText;
  const OpenSettingBottomSheet({required this.contentText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          Container(width: 46, height: 4, color: Colors.grey,),
          Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25), child: Center(child: Text("$contentText", style: TextStyle(fontFamily: ConstantFont.metropolis, fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),)),
          ElevatedButton(onPressed: (){Get.back();PhotoManager.openSetting();},
              child: Center(child: Text("OPEN SETTING", style: TextStyle(fontFamily: ConstantFont.metropolis, fontWeight: FontWeight.bold),)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ConstantColor.primaryBlack),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15))
              ),
          )
        ],
      ),
    );
  }
}
