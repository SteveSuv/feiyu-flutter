import 'package:app/components/components.dart';
import 'package:flutter/material.dart';
import 'package:app/components/global.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:app/pages/home/home.dart';
import 'package:app/pages/msg/msg.dart';
import 'package:app/pages/course/course.dart';
import 'package:app/pages/me/me.dart';


class Index extends StatefulWidget {
  Index({this.arg});
  final arg;
  @override
  State<StatefulWidget> createState() {
    return IndexState();
  }
}

class IndexState extends State<Index> {
  int currentIndex = 0;
  List<Widget> pages = [
    Home(),
    Course(),
    Msg(),
    Me()
  ];

  final bottomnavitems = [
    BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.offline_bolt,
          color: themeColor,
        ),
        icon: Icon(OMIcons.offlineBolt),
        title: Container(height: 0.0)),
    BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.explore,
          color: themeColor,
        ),
        icon: Icon(OMIcons.explore),
        title: Container(height: 0.0)),
    BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.watch_later,
          color: themeColor,
        ),
        icon: Icon(OMIcons.watchLater),
        title: Container(height: 0.0)),
    BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.account_circle,
          color: themeColor,
        ),
        icon: Icon(OMIcons.accountCircle),
        title: Container(height: 0.0)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(index: currentIndex,children: pages,),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: bottomnavitems,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ));
  }
}
