import 'dart:async';

import 'package:app/components/global.dart';
import 'package:app/components/components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app/components/api.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  final arg;
  Login({Key key, this.arg}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return LoginState(arg: arg);
  }
}

class LoginState extends State<Login> {
  LoginState({this.arg});
  var arg;

  var emailcontroller = TextEditingController();
  var pwdcontroller = TextEditingController();

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
    if (arg != null) {
      emailcontroller.text = arg['login_email'].toString();
      pwdcontroller.text = arg['login_pwd'].toString();
      login_avatar = arg['login_avatar'].toString();
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String login_email;
  String login_pwd;
  var login_avatar;
  String author_ip = '';

  void forSubmitted() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      loading(context);
      resp() async {
        var user_email;
        var user_id;
        if (login_email.indexOf('@') >= 0) {
          user_email = login_email.toLowerCase();
        } else {
          user_id = login_email.toString();
        }
        var user_pwd = login_pwd.toString();
        var user_logindate = time()['showtime'];
        var user_ip = author_ip;

        var res = await api_login(
            user_pwd, user_logindate, user_ip, user_id, user_email);
        Navigator.pop(context);
        if (res == '2') {
          toast('账号或密码错误', context);
        } else {
          setItem('user_name', res['user_name'].toString());
          setItem('user_id', res['user_id'].toString());
          setItem('access_token', res['access_token'].toString());
          setItem('user_avatar', res['user_avatar'].toString());
          RestartWidget.restartApp(context);
        }
      }

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
        title: Text('登录'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(50.0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('密码登录', style: TextStyle(color: Colors.black, fontSize: 30))
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Center(
                    child: (login_avatar == null)
                        ? CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/head.jpg'),
                          )
                        : avatar(context, '', login_avatar, false)),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailcontroller,
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '邮箱或飞羽号',
                  ),
                  validator: (val) {
                    return val.isEmpty ? "请填写邮箱或飞羽号" : null;
                  },
                  onSaved: (val) {
                    login_email = val;
                  },
                ),
                Divider(
                  height: 0,
                ),
                TextFormField(
                  controller: pwdcontroller,
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '密码',
                  ),
                  obscureText: true,
                  validator: (val) {
                    return val.isEmpty ? "请填写密码" : null;
                  },
                  onSaved: (val) {
                    login_pwd = val;
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
                "登录",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                highlightColor: Colors.transparent,
                child: Text('忘记密码',
                    style: TextStyle(color: themeColor, fontSize: 12)),
                onPressed: () {
                  Navigator.pushNamed(context, '/findpwd');
                },
              ),
              FlatButton(
                highlightColor: Colors.transparent,
                child: Text('注册账号',
                    style: TextStyle(color: themeColor, fontSize: 12)),
                onPressed: () {
                  Navigator.pushNamed(context, '/sign');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
