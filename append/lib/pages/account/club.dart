import 'package:app/components/global.dart';
import 'package:flutter/material.dart';

class Club extends StatelessWidget {
  Club({this.arg});
  final arg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeColor,
        title: Text('会员中心'),
      ),
      body: Center(
        child: Text('Club'),
      ),
    );
  }
}
