import 'package:app/components/global.dart';
import 'package:app/components/components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app/components/api.dart';

class CourseEdit extends StatefulWidget {
  final arg;
  CourseEdit({Key key, this.arg}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return CourseEditState(arg: arg);
  }
}

class CourseEditState extends State<CourseEdit> {
  CourseEditState({this.arg});
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

  String course_title;
  String course_content;
  String author_ip = '';

  resp() async {
    var res = await api_adddata(
      'course',
      {
        'course_author': {
          'name': username,
          'avatar': useravatar,
          'ip': author_ip,
        },
        'course_title': course_title.toString(),
        'course_content': course_content.toString(),
        'course_showtime': time()['showtime'],
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
        title: Text('新建课程'),
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
                    hintText: '课程全名',
                  ),
                  validator: (val) {
                    return val.isEmpty ? "请填写名称" : null;
                  },
                  onSaved: (val) {
                    course_title = val;
                  },
                ),
                Divider(
                  height: 0,
                ),
                TextFormField(
                    minLines: 10,
                    maxLines: 1000,
                    cursorColor: themeColor,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: '课程描述（请参考相关百科）',
                      fillColor: Colors.white,
                      focusColor: Colors.black,
                    ),
                    validator: (val) {
                      return val.isEmpty ? "描述不能为空" : null;
                    },
                    onSaved: (val) {
                      course_content = val;
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
