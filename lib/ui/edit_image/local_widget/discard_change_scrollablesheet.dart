import 'package:edit_photo/constant/fonts/constant_font.dart';
import 'package:flutter/material.dart';

class DiscardChangeScrollableSheet extends StatelessWidget {
  final VoidCallback discardChangeOnPressed;
  final VoidCallback cancelOnPressed;
  const DiscardChangeScrollableSheet({required this.cancelOnPressed, required this.discardChangeOnPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.center,
      children: [
        TextButton(onPressed: discardChangeOnPressed, child: Text("Discard Changes", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.red),)),
        TextButton(onPressed: cancelOnPressed, child: Text("Cancel", style: TextStyle(fontFamily: ConstantFont.metropolis, color: Colors.black)))
      ],
    );
  }
}
