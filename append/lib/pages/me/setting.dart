import 'package:app/components/global.dart';
import 'package:flutter/material.dart';


class Setting extends StatelessWidget {
  Setting({this.arg});
  final arg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeColor,
        title: Text('系统设置'),
      ),
      body: Center(
        child: Text('setting'),
      ),
    );
  }
}