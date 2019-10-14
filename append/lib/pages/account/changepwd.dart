import 'package:app/components/global.dart';
import 'package:app/components/components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app/components/api.dart';

class ChangePwd extends StatefulWidget {
  final arg;
  ChangePwd({Key key, this.arg}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ChangePwdState(arg: arg);
  }
}

class ChangePwdState extends State<ChangePwd> {
  ChangePwdState({this.arg});
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

  var pwdcontroller = TextEditingController();

  String newpwd;
  String newpwd2;
  String author_ip = '';

  resp() async {
    // var res = await api_adddata();
    var res = '1';
    Navigator.pop(context);
    if (res == '1') {
      Navigator.pop(context);
      toast('更改密码成功', context);
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
        title: Text('更改密码'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(50.0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('重设密码', style: TextStyle(color: Colors.black, fontSize: 30))
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
                    child: (useravatar == '')
                        ? CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/head.jpg'),
                          )
                        : avatar(context, '', useravatar, false)),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: pwdcontroller,
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '新密码',
                  ),
                  validator: (val) {
                    return val.length < 6 ? "密码长度太短" : null;
                  },
                  onSaved: (val) {
                    newpwd = val;
                  },
                ),
                Divider(
                  height: 0,
                ),
                TextFormField(
                  cursorColor: themeColor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '确认密码',
                  ),
                  obscureText: true,
                  validator: (val) {
                    return (val != pwdcontroller.text) ? "两次输入密码不相同" : null;
                  },
                  onSaved: (val) {
                    newpwd2 = val;
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
                "确认修改",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
