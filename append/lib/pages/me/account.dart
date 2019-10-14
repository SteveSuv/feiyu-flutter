import 'dart:async';
import 'package:app/components/components.dart';
import 'package:app/components/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  Account({this.arg});
  final arg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: themeColor,
          title: Text('账号设置'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.vpn_key, color: themeColor),
              title: Text('更改密码'),
              subtitle: Text('Change your password'),
              onTap: () {
                Navigator.pushNamed(context, '/changepwd');
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: themeColor),
              title: Text('更改头像'),
              subtitle: Text('Change your avatar'),
              onTap: () {
                Navigator.pushNamed(context, '/changeavatar');
              },
            ),
            ListTile(
              leading: Icon(Icons.stars, color: themeColor),
              title: Text('前往空间'),
              subtitle: Text('Goto your zone'),
              onTap: () {
                Navigator.pushNamed(context, '/zone', arguments: username);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                shape: circle(5.0),
                buttonColor: Colors.redAccent,
                child: RaisedButton(
                  highlightElevation: 0,
                  elevation: 0,
                  onPressed: () {
                    alert(context, '提示', '确定退出账号吗', () async {
                      Navigator.pop(context);
                      loading(context);
                      Response res = await service()
                          .post('/exit', data: {'user_name': username});
                      Navigator.pop(context);
                      if (res.data == '1') {
                        removeItem('user_id');
                        removeItem('user_name');
                        removeItem('user_avatar');
                        removeItem('access_token');
                        userid = '';
                        username = '';
                        useravatar = default_avatar;
                        RestartWidget.restartApp(context);
                      }
                    });
                  },
                  child: Text(
                    "退出账号",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
