import 'package:app/components/global.dart';
import 'package:app/components/components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app/components/api.dart';

class FeedbackEdit extends StatefulWidget {
  final arg;
  FeedbackEdit({Key key, this.arg}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return FeedbackEditState(arg: arg);
  }
}

class FeedbackEditState extends State<FeedbackEdit> {
  FeedbackEditState({this.arg});
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

  String feedback_title;
  String feedback_content;
  List feedback_images = [];
  String author_ip = '';

  resp() async {
    var images = [];
    if (feedback_images.length != 0) {
      FormData formData = FormData.from({"files": tofiles(feedback_images)});
      Response res2 = await service().put(
        "/uploads",
        data: formData,
        onSendProgress: (sent, total) {
          toast('已完成'+toprecent(sent/total), context);
        },
      );
      var resarr = res2.data;
      for (var i = 0; i < resarr.length; i++) {
        images.add('$serverip/upload/${resarr[i]['filename']}');
      }
    }
    
    var res = await api_adddata(
      'feedback',
      {
        'feedback_author': {
          'name': username,
          'avatar': useravatar,
          'ip': author_ip,
        },
        'feedback_title': feedback_title.toString(),
        'feedback_content': feedback_content.toString(),
        'feedback_images': images,
        'feedback_showtime': time()['showtime'],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeColor,
        title: Text('发送反馈'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '标题',
                  ),
                  validator: (val) {
                    return val.isEmpty ? "请填写标题" : null;
                  },
                  onSaved: (val) {
                    feedback_title = val;
                  },
                ),
                Divider(
                  height: 0,
                ),
                TextFormField(
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
                      feedback_content = val;
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: pics(feedback_images, (e) {
                    alert(context, '提示', '确认移除这张图片吗', () {
                      setState(() {
                        feedback_images.removeAt(e);
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
                      if (feedback_images.length >= 9) {
                        alert(context, '提示', '最多只能选择九张图片哦', () {
                          Navigator.pop(context);
                        });
                      } else {
                        imgpick(context, (e) {
                          setState(() {
                            
                              feedback_images.addAll(e);
                           
                          });
                        });
                      }
                    }),
            

              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical:20, horizontal: 15),
              child: ButtonTheme(
                height: 50,
                shape: circle(5.0),
                buttonColor: themeColor,
                child: RaisedButton(highlightElevation: 0,
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
