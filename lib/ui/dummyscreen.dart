import 'dart:io';

import 'package:flutter/material.dart';

class DummyScreen extends StatefulWidget {
  final File? file;
  const DummyScreen({this.file,Key? key}) : super(key: key);

  @override
  _DummyScreenState createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Image.file(widget.file!)
          ],
        ),
      ),
    );
  }
}
