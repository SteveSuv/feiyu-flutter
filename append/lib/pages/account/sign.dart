import 'dart:io';

import 'package:app/components/api.dart';
import 'package:app/components/components.dart';
import 'package:app/components/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class Sign extends StatefulWidget {
  Sign({this.arg});
  final arg;
  @override
  State<StatefulWidget> createState() {
    return SignState();
  }
}

class SignState extends State<Sign> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String sign_email;
  String sign_name;
  String sign_pwd;
  String sign_repwd;
  var sign_avatar;

  void forSubmitted() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      loading(context);
      resp() async {
        var avatar;
        if (sign_avatar == null) {
          avatar = default_avatar;
        } else {
          FormData formData = FormData.from({
            "file": UploadFileInfo(sign_avatar, fileinfo(sign_avatar)['name'])
          });
          Response res2 = await service().post("/upload", data: formData);
          avatar = '$serverip/upload/${res2.data['filename']}';
        }

        var user_email = sign_email.toLowerCase();
        var user_name = sign_name.toString();
        var user_pwd = sign_pwd.toString();
        var user_avatar = avatar;
        var sendtime = time()['sendtime'];

        var res = await api_sign(
            user_email, user_name, user_pwd, user_avatar, sendtime);
        Navigator.pop(context);
        print(res);
        if (res == '1') {
          toast(
            '注册成功',
            context,
          );
          Navigator.pushNamed(context, '/login', arguments: {
            'login_email': sign_email,
            'login_pwd': sign_pwd,
            'login_avatar': avatar
          });
        }
        if (res == '2') {
          toast('该邮箱已被注册', context);
        }
        if (res == '3') {
          toast('该用户名已存在', context);
        }
      }

      resp();
    }
  }

  var pwdcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeColor,
        title: Text('注册'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(50.0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('注册账号', style: TextStyle(color: Colors.black, fontSize: 30))
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                sign_avatar == null
                    ? OutlineBtn(
                        child: Icon(
                          OMIcons.accountCircle,
                          color: themeColor,
                          size: 30,
                        ),
                        onPressed: () {
                          imgpick(context, (e) {
                            setState(() {
                              sign_avatar = e[0];
                            });
                          });
                        },
                        shape: CircleBorder())
                    : OutlineBtn(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: FileImage(sign_avatar),
                          radius: 30,
                        ),
                        onPressed: () {
                          imgpick(context, (e) {
                            setState(() {
                              sign_avatar = e[0];
                            });
                          });
                        },
                        shape: CircleBorder()),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    hintText: '邮箱',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: (val) {
     
                    if(val.indexOf('@')<0){
                      return '邮箱格式不符合规范';
                    }
                    if( val.length < 8){
                      return "邮箱长度太短";
                    }
                  },
                  onSaved: (val) {
                    sign_email = val;
                  },
                ),
                Divider(
                  height: 0,
                ),
                TextFormField(
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    hintText: '昵称',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: (val) {
                    return (val.length < 2 || val.length > 15)
                        ? "昵称不符合规则"
                        : null;
                  },
                  onSaved: (val) {
                    sign_name = val;
                  },
                ),
                Divider(
                  height: 0,
                ),
                TextFormField(
                  controller: pwdcontroller,
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    hintText: '密码',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  obscureText: true,
                  validator: (val) {
                    return val.length < 6 ? "密码长度太短" : null;
                  },
                  onSaved: (val) {
                    sign_pwd = val;
                  },
                ),
                Divider(
                  height: 0,
                ),
                TextFormField(
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    hintText: '重复密码',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  obscureText: true,
                  validator: (val) {
                    return (val != pwdcontroller.text) ? "两次密码不一致" : null;
                  },
                  onSaved: (val) {
                    sign_repwd = val;
                  },
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          SizedBox(
            height: 30,
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
                "注册",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
