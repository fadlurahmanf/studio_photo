import 'package:edit_photo/constant/color/constant_color.dart';
import 'package:edit_photo/constant/fonts/constant_font.dart';
import 'package:edit_photo/ui/repository/repository_screen.dart';
import 'package:edit_photo/ui/studio/studio_screen.dart';
import 'package:flashy_tab_bar/flashy_tab_bar.dart';
import 'package:flutter/material.dart';

class HomePageScreen extends StatelessWidget {
  final int? indexTab;
  const HomePageScreen({this.indexTab=0,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePageLayout(indexTab: indexTab,);
  }
}

class HomePageLayout extends StatefulWidget {
  final int? indexTab;
  const HomePageLayout({this.indexTab=0, Key? key}) : super(key: key);

  @override
  _HomePageLayoutState createState() => _HomePageLayoutState();
}

class _HomePageLayoutState extends State<HomePageLayout> {
  int indexTab = 0;
  List<Widget> _tabs = <Widget>[
    StudioScreen(),
    RepositoryScreen()
  ];

  @override
  void initState() {
    super.initState();
    if(widget.indexTab!=null) indexTab = widget.indexTab!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(height: MediaQuery.of(context).padding.top,color: ConstantColor.primaryBlack,),
          Expanded(child: _tabs[indexTab])
        ],
      ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: indexTab,
        onItemSelected: (int index){
          setState(() {
            indexTab = index;
          });
        },
        showElevation: true,
        items: [
          FlashyTabBarItem(
              icon: Icon(Icons.search),
              activeColor: ConstantColor.primaryBlack,
              title: Text("          Search          ", style: TextStyle(fontFamily: ConstantFont.metropolis, color: ConstantColor.primaryBlack),)
          ),
          FlashyTabBarItem(
              icon: Icon(Icons.drive_folder_upload),
              title: Text("          Repository          ",  style: TextStyle(fontFamily: ConstantFont.metropolis, color: ConstantColor.primaryBlack),)
          ),
        ],
      ),
    );
  }
}

