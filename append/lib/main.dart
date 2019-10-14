import 'dart:io'; //提供Platform接口
import 'package:app/components/global.dart';
import 'package:flutter/services.dart'; //提供SystemUiOverlayStyle
import 'package:app/components/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '飞羽',
        theme: ThemeData.light(),
        initialRoute: '/',
        onGenerateRoute: getRoute,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
      ),
    );
  }
}
