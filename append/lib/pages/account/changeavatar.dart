import 'dart:io';

import 'package:app/components/global.dart';
import 'package:app/components/components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app/components/api.dart';

class ChangeAvatar extends StatefulWidget {
  final arg;
  ChangeAvatar({Key key, this.arg}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ChangeAvatarState(arg: arg);
  }
}

class ChangeAvatarState extends State<ChangeAvatar> {
  ChangeAvatarState({this.arg});
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

  var author_ip;
  var newavatar;
  var avatar;

  resp() async {
    FormData formData = FormData.from(
        {"file": UploadFileInfo(newavatar, fileinfo(newavatar)['name'])});
    Response res2 = await service().post("/upload", data: formData);
    avatar = '$serverip/upload/${res2.data['filename']}';

    // var res = await api_adddata(avatar);
    var res = '1';
    Navigator.pop(context);
    if (res == '1') {
      RestartWidget.restartApp(context);
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
          title: Text('更换头像'),
        ),
        body: ListView(padding: const EdgeInsets.all(50.0), children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('更换头像', style: TextStyle(color: Colors.black, fontSize: 30))
            ],
          ),
          SizedBox(
            height: 100,
          ),
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Center(
                    child: OutlineBtn(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: (newavatar == null)
                              ? NetworkImage(useravatar)
                              : FileImage(newavatar),
                          radius: 30,
                        ),
                        onPressed: () {
                          imgpick(context, (e) {
                            setState(() {
                              newavatar = e[0];
                            });
                          });
                        },
                        shape: CircleBorder())),
                SizedBox(
                  height: 100,
                ),
                ButtonTheme(
                  minWidth: double.infinity,
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
                      "确认更换",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
