import 'package:app/components/components.dart';
import 'package:app/components/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class Findpwd extends StatefulWidget {
  Findpwd({this.arg});
  final arg;
  @override
  State<StatefulWidget> createState() {
    return FindpwdState();
  }
}

class FindpwdState extends State<Findpwd> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String findpwd_email;
  String findpwd_code;
  String findpwd_pwd;
  String findpwd_repwd;

  void forSubmitted() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();

      resp() async {
        Response res = await service().post('/findpwd', data: {
          "user_email": findpwd_email.toLowerCase(),
          'user_code': findpwd_code + '',
          "user_pwd": findpwd_pwd + ''
        });
        print(res.data);
        if (res.data == '1') {
          toast('注册成功', context);
          Navigator.pushNamed(context, '/login', arguments: {
            'login_email': findpwd_email,
            'login_pwd': findpwd_pwd
          });
        }
        if (res.data == '2') {
          toast('该邮箱已被注册', context);
        }
        if (res.data == '3') {
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
        title: Text('忘记密码'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(50.0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('重置密码', style: TextStyle(color: Colors.black, fontSize: 30))
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    hintText: '邮箱',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: (val) {
                    return val.length < 8 ? "邮箱长度太短" : null;
                  },
                  onSaved: (val) {
                    findpwd_email = val;
                  },
                ),
                Divider(
                  height: 0,
                ),
                TextFormField(
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    hintText: '验证码',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: (val) {
                    return (val.length < 2 || val.length > 15)
                        ? "验证码格式错误"
                        : null;
                  },
                  onSaved: (val) {
                    findpwd_code = val;
                  },
                ),
                Divider(
                  height: 0,
                ),
                TextFormField(
                  controller: pwdcontroller,
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    hintText: '新密码',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  obscureText: true,
                  validator: (val) {
                    return val.length < 6 ? "密码长度太短" : null;
                  },
                  onSaved: (val) {
                    findpwd_pwd = val;
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
                    findpwd_repwd = val;
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
            child: RaisedButton(highlightElevation: 0,
              elevation: 0,
              onPressed: () {
                forSubmitted();
              },
              child: Text(
                "提交",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
