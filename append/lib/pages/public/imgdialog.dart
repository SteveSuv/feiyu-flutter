import 'package:flutter/material.dart';
import 'package:app/components/components.dart';
import 'package:app/components/global.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Imgdialog extends StatefulWidget {
  final arg;
  Imgdialog({Key key, this.arg}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ImgdialogState(arg: arg);
  }
}

class ImgdialogState extends State<Imgdialog> {
  final arg;
  ImgdialogState({this.arg});

  int currentIndex;
  int initialIndex;
  int length;
  @override
  void initState() {
    currentIndex = arg[1];
    initialIndex = arg[1];
    length = arg[0].length;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('${currentIndex + 1} / ${length}'),
        centerTitle: true,
        actions: <Widget>[Shareicon(arg: '分享图片:${arg[0][currentIndex]}')],
      ),
      body: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollDirection: Axis.horizontal,
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(arg[0][index]),
                    initialScale: PhotoViewComputedScale.contained * 1,
                  );
                },
                itemCount: arg[0].length,
                loadingChild: pageload(),
                backgroundDecoration: BoxDecoration(
                  color: Colors.black,
                ),
                pageController: PageController(initialPage: initialIndex),
                onPageChanged: onPageChanged,
              ),
            ],
          )),
    );
  }
}
