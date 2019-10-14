import 'package:app/components/global.dart';

import 'package:app/pages/me/account.dart';

import 'package:app/pages/public/imgdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// 启动页
import 'package:app/pages/public/splash.dart';
// 首页
import 'package:app/pages/public/index.dart';

// 编辑页

import 'package:app/pages/edit/course_edit.dart';
import 'package:app/pages/edit/file_edit.dart';

import 'package:app/pages/edit/comment_edit.dart';

import 'package:app/pages/edit/topic_edit.dart';
import 'package:app/pages/edit/feedback_edit.dart';

// 我的
import 'package:app/pages/me/zone.dart';
import 'package:app/pages/me/setting.dart';
import 'package:app/pages/me/about.dart';

// 公共页
import 'package:app/pages/public/search.dart';
import 'package:app/pages/public/result.dart';
import 'package:app/pages/public/comment_detail.dart';
import 'package:app/pages/public/intro.dart';

// 详情页
import 'package:app/pages/home/topic_detail.dart';
import 'package:app/pages/course/course_detail.dart';
import 'package:app/pages/course/file_detail.dart';

// 账号
import 'package:app/pages/account/club.dart';
import 'package:app/pages/account/findpwd.dart';
import 'package:app/pages/account/login.dart';
import 'package:app/pages/account/sign.dart';
import 'package:app/pages/account/updateaccount.dart';
import 'package:app/pages/account/changepwd.dart';
import 'package:app/pages/account/changeavatar.dart';

var routes = {
  // 启动页
  '/': (arguments) => Splash(),
  // 首页
  '/index': (arguments) => Index(arg: arguments),

  // 编辑页
  '/topic_edit': (arguments) => TopicEdit(arg: arguments),

  '/comment_edit': (arguments) => CommentEdit(arg: arguments),
  '/file_edit': (arguments) => FileEdit(arg: arguments),
  '/course_edit': (arguments) => CourseEdit(arg: arguments),
  '/feedback_edit': (arguments) => FeedbackEdit(arg: arguments),

  // 详情页
  '/topic_detail': (arguments) => TopicDetail(arg: arguments),
  '/course_detail': (arguments) => CourseDetail(arg: arguments),
  '/file_detail': (arguments) => FileDetail(arg: arguments),

  '/comment_detail': (arguments) => CommentDetail(arg: arguments),

  // 我的
  '/zone': (arguments) => Zone(arg: arguments),
  '/setting': (arguments) => Setting(arg: arguments),
  '/about': (arguments) => About(arg: arguments),
  '/account': (arguments) => Account(arg: arguments),

  // 公共

  '/search': (arguments) => Search(arg: arguments),
  '/result': (arguments) => Result(arg: arguments),
  '/intro': (arguments) => Intro(arg: arguments),
  '/imgdialog': (arguments) => Imgdialog(arg: arguments),

  // 账号
  '/login': (arguments) => Login(arg: arguments),
  '/sign': (arguments) => Sign(arg: arguments),
  '/findpwd': (arguments) => Findpwd(arg: arguments),
  '/updateaccount': (arguments) => UpdateAccount(arg: arguments),
  '/club': (arguments) => Club(arg: arguments),
  '/changepwd': (arguments) => ChangePwd(arg: arguments),
  '/changeavatar': (arguments) => ChangeAvatar(arg: arguments),
  // 其他
};

Route<dynamic> getRoute(RouteSettings settings) {
  final String name = settings.name;
  final arg = settings.arguments;
  final Function pageContentBuilder = routes[name];
  final Function loginBuilder = routes['/login'];
  if (name == '/' ||
      name == '/intro' ||
      name == '/login' ||
      name == '/sign' ||
      name == '/findpwd') {
    return MaterialPageRoute(builder: (context) => pageContentBuilder(arg));
  } else {
    if (username == '' || username == null) {
      return MaterialPageRoute(builder: (context) => loginBuilder(arg));
    } else {
      return MaterialPageRoute(builder: (context) => pageContentBuilder(arg));
    }
  }
}
