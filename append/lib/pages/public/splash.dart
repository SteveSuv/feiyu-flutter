import 'dart:async';
import 'package:app/components/api.dart';
import 'package:app/components/global.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTime() async {
    await getItem('themeColor').then((e) {
      themeColor = (e == null) ? Color(4279213400) : Color(int.parse(e));
    });

    await getItem('user_name').then((e) {
      username = (e == null) ? '' : e;
    });

    await getItem('user_id').then((e) {
      userid = (e == null) ? '' : e;
    });

    await getItem('user_avatar').then((e) {
      useravatar = (e == null) ? '' : e;
    });

    await getItem('firstload').then((e) {
      firstload = (e == null) ? 'true' : 'false';
    });

    await getItem('historys').then((e) {
      historys = (e == null) ? '' : e;
    });

    await getItem('access_token').then((e) async {
      var res = await api_islogin(username, e);
      if (res != '1') {
        removeItem('user_id');
        removeItem('user_name');
        removeItem('user_avatar');
        removeItem('access_token');
        userid = '';
        username = '';
        useravatar = default_avatar;
        navigationPage();
      } else {
        Timer(Duration(seconds: 2), navigationPage);
        username = username;
        useravatar = useravatar;
        userid = userid;
        Toast.show('$username，欢迎回来', context,
            textColor: Colors.white,
            backgroundColor: themeColor,
            gravity: Toast.TOP,
            duration: 2);
      }
    });
  }

  void navigationPage() {
    firstload == 'true'
        ? Navigator.of(context).pushReplacementNamed('/intro')
        : Navigator.of(context).pushReplacementNamed('/index');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/splash.png',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
