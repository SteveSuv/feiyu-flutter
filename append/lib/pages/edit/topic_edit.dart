import 'dart:core';

import 'package:app/components/api.dart';
import 'package:app/components/global.dart';
import 'package:app/components/components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TopicEdit extends StatefulWidget {
  final arg;
  TopicEdit({Key key, this.arg}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return TopicEditState(arg: arg);
  }
}

class TopicEditState extends State<TopicEdit> {
  TopicEditState({this.arg});
  var arg;

  @override
  void initState() {
    super.initState();
    setip() async {
      var ip = await getip();
      print(ip);
      setState(() {
        author_ip = ip;
      });
    }

    setip();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String topic_title;
  String topic_content;
  List topic_images = [];
  String author_ip = '';

  resp() async {
    var images = [];
    if (topic_images.length != 0) {
      FormData formData = FormData.from({"files": tofiles(topic_images)});
      Response res2 = await service().put(
        "/uploads",
        data: formData,
        onSendProgress: (sent, total) {
          toast('已完成' + toprecent(sent / total), context);
        },
      );
      var resarr = res2.data;
      for (var i = 0; i < resarr.length; i++) {
        images.add('$serverip/upload/${resarr[i]['filename']}');
      }
    }

    var res = await api_adddata(
      'topic',
      {
        'topic_author': {
          'name': username,
          'avatar': useravatar,
          'ip': author_ip,
        },
        'topic_label': '$arg',
        'topic_title': topic_title.toString(),
        'topic_content': topic_content.toString(),
        'topic_images': images,
        'topic_showtime': time()['showtime'],
        'sendtime': time()['sendtime'],
      },
    );
    Navigator.pop(context);
    if (res == '1') {
      Navigator.pop(context);
      toast('发布成功', context);
    }
  }

  void forSubmitted() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      loading(context);
      resp();
    }
  }

  var textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeColor,
        title: Text('发表动态'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                labelfield(arg),
                TextFormField(
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '标题(可不填写)',
                  ),
                  onSaved: (val) {
                    val = (val == '')
                        ? textcontroller.text.toString().substring(0, 20) +
                            '...'
                        : val;
                    topic_title = val;
                  },
                ),
                Divider(
                  height: 0,
                ),
                TextFormField(
                    controller: textcontroller,
                    minLines: 3,
                    maxLines: 1000,
                    cursorColor: themeColor,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: '说点什么吧',
                      fillColor: Colors.white,
                      focusColor: Colors.black,
                    ),
                    validator: (val) {
                      return val.isEmpty ? "内容不能为空" : null;
                    },
                    onSaved: (val) {
                      topic_content = val;
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: pics(topic_images, (e) {
                    alert(context, '提示', '确认移除这张图片吗', () {
                      setState(() {
                        topic_images.removeAt(e);
                        Navigator.pop(context);
                      });
                    });
                  }),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                    leading: Icon(
                      Icons.photo,
                      color: themeColor,
                    ),
                    title: Text('选择图片'),
                    onTap: () {
                      if (topic_images.length >= 9) {
                        alert(context, '提示', '最多只能选择九张图片哦', () {
                          Navigator.pop(context);
                        });
                      } else {
                        imgpick(context, (e) {
                          setState(() {
                            topic_images.addAll(e);
                          });
                        });
                      }
                    }),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: ButtonTheme(
                height: 50,
                shape: circle(5.0),
                buttonColor: themeColor,
                child: RaisedButton(
                  highlightElevation: 0,
                  elevation: 0,
                  onPressed: () {
                    forSubmitted();
                  },
                  child: Text(
                    "发布",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
