import 'package:app/components/global.dart';
import 'package:flutter/material.dart';

class UpdateAccount extends StatelessWidget {
  UpdateAccount({this.arg});
  final arg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeColor,
        title: Text('更新信息'),
      ),
      body: Center(
        child: Text('UpdateAccount'),
      ),
    );
  }
}
