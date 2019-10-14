import 'package:app/components/global.dart';
import 'package:app/components/components.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class Intro extends StatefulWidget {
  Intro({this.arg});
  final arg;
  @override
  State<StatefulWidget> createState() {
    return IntroState();
  }
}

class IntroState extends State<Intro> {
  List<Slide> slides = List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: '极简设计',
        colorBegin: Colors.red.withOpacity(0.8),
        colorEnd: Colors.red,
        description: "纯Flutter配合谷歌原生材质设计简洁大方",
      ),
    );
    slides.add(
      new Slide(
        title: "交流社区",
        description: '拥有以论坛发帖机制的动态内容板块',
        colorBegin: Colors.indigo.withOpacity(0.7),
        colorEnd: Colors.indigo,
      ),
    );
    slides.add(
      new Slide(
        title: "课程资料",
        description: '自由分享和免费下载所需要的课程资料',
        colorBegin: themeColor.withOpacity(0.6),
        colorEnd: themeColor,
      ),
    );
  }

  void onDonePress() async {
    await setItem('firstload', 'false');
    Navigator.pushReplacementNamed(context, '/index');
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
        slides: this.slides,
        onDonePress: this.onDonePress,
        colorActiveDot: Colors.white);
  }
}
