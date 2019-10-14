
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'dart:core';
import 'dart:io';

import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';

import 'package:file_picker/file_picker.dart';

import 'package:dio/dio.dart';

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// 全局变量
var firstload = 'true';
var theme = ThemeData.light();
var themeColor = Color(4279213400);
var historys = '';
var adshow = false;

// 用户变量
var username = '';
var userid = '';
var useravatar = default_avatar;

// 其他变量
var serverip = 'http://172.106.33.150:4000';
var localip = 'http://192.168.203.1:4000';
var default_avatar = 'https://i.loli.net/2019/10/08/hZulBDEdU2pIsqN.png';
var domain='http://feiyu.fescover.com';
var adurl='$serverip/upload/ad.jpg';

// 网络
service() {
  Dio dio = new Dio();
  // 线上
  // dio.options.baseUrl = '$serverip/api';

  // // 本地
  dio.options.baseUrl = '$localip/api';
  return dio;
}

// 持久化储存
setItem(key, item) async {
  var prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, item);
}

getItem(key) async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

removeItem(key) async {
  var prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

clearall() async {
  var prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

// 等待
wait(int seconds) async {
  return await Future.delayed(Duration(milliseconds: seconds));
}

// 文件信息
fileinfo(file) {
  var len = file.toString().length;
  var arr1 = file.toString().substring(0, len - 1).split('/');
  var name = arr1[arr1.length - 1];
  var arr2 = name.toString().split('.');
  var type = arr2[arr2.length - 1];
  return {'len': len, 'name': name, 'type': type};
}

// list to map
tomap(list) {
  return Map.fromIterable(list, key: (v) => v[0], value: (v) => v[1]);
}

// time
time() {
  DateTime today = new DateTime.now();
  var y = today.year.toString().substring(2);
  var m = today.month.toString().padLeft(2, '0');
  var d = today.day.toString().padLeft(2, '0');
  var h = today.hour.toString().padLeft(2, '0');
  var n = today.minute.toString().padLeft(2, '0');
  var s = today.second.toString().padLeft(2, '0');
  var ms = today.microsecond.toString().padLeft(3, '0');
  var w = today.weekday.toString();
  var showtime = '$y-$m-$d $h:$n';
  var sendtime = int.parse('$y$m$d$h$n$s$ms');
  return {
    'year': y,
    'month': m,
    'day': d,
    'hour': h,
    'minute': n,
    'second': s,
    'microsecond': ms,
    'week': w,
    'showtime': showtime,
    'sendtime': sendtime
  };
}

// arr to filesarr
tofiles(arr) {
  var brr = [];
  for (var i = 0; i < arr.length; i++) {
    brr.add(UploadFileInfo(arr[i], fileinfo(arr[i])['name']));
  }
  return brr;
}

// ip
getip() async {
  // 外网ip
  var ipRegexp = RegExp(
      r'((?:(?:25[0-5]|2[0-4]\d|(?:1\d{2}|[1-9]?\d))\.){3}(?:25[0-5]|2[0-4]\d|(?:1\d{2}|[1-9]?\d)))');
  var url = 'http://www.ip.cn/';
  var client = HttpClient();
  var req = await client.getUrl(Uri.parse(url));
  var res = await req.close();
  var resip;
  await res.transform(utf8.decoder).forEach((line) {
    ipRegexp.allMatches(line).forEach((match) {
      resip = match.group(0);
    });
  });
  return resip;
}

// contextsize
ctxsize() {
  final width = window.physicalSize.width;
  final height = window.physicalSize.height;
  return {'width': width, 'height': height};
}

// File to filename
tofilename(file) {
  return file
      .toString()
      .split('/')
      .reversed
      .toList()[0]
      .split('')
      .reversed
      .toList()
      .sublist(1)
      .reversed
      .join('')
      .toString();
}



circle(radius) {
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
}

// toast
toast(msg, context, [bool center = false]) {
  return !center
      ? Toast.show(msg, context,
          textColor: Colors.white,
          backgroundColor: themeColor,
          gravity: Toast.BOTTOM,
          duration: 2)
      : Toast.show(msg, context,
          textColor: Colors.white,
          backgroundColor: themeColor,
          gravity: Toast.CENTER,
          duration: 2);
}

// 分享
share(String text) {
  return Share.share(text);
}

// url_lancher
urllaunch(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// 文件选取
void pickfile(callback,
    [FileType type = FileType.ANY, String fileExtension]) async {
  List<File> files =
      await FilePicker.getMultiFile(type: type, fileExtension: fileExtension);
  await callback(files);
}

// 小数转百分数(一般用于进度)
toprecent(double valuenum, [int fixnum = 2]) {
  return ((valuenum * 100).toStringAsFixed(fixnum)) + '%';
}
