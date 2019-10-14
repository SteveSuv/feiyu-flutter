import 'package:app/components/global.dart';
import 'package:app/components/components.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class Search extends StatefulWidget {
  Search({this.arg});
  final arg;
  @override
  State<StatefulWidget> createState() {
    return SearchState(arg: this.arg);
  }
}

class SearchState extends State<Search> {
  SearchState({this.arg});
  final arg;
  var controller = TextEditingController();

  historylabels(arr) {
    var brr = [];
    for (var i = 0; i < arr.length; i++) {
      brr.add(Transform(
          transform: Matrix4.identity()..scale(0.8),
          child: ActionChip(
            pressElevation: 0,
            shape: circle(5.0),
            label: Text(
              arr[i],
              style: TextStyle(color: themeColor),
            ),
            backgroundColor: themeColor.withOpacity(0.1),
            onPressed: () {
              Navigator.pushNamed(context, '/result', arguments: arr[i]);
            },
          )));
    }
    return brr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(500),
          child: Card(
            margin: EdgeInsets.only(top: 40, left: 30, right: 30),
            elevation: 1,
            shape: circle(10.0),
            clipBehavior: Clip.hardEdge,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextField(
                autofocus: true,
                controller: controller,
                cursorColor: themeColor,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.arrow_back, color: themeColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  hoverColor: themeColor,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: themeColor),
                    onPressed: () async {
                      if (controller.text == null || controller.text == '') {
                        toast('请输入关键字', context, true);
                      } else {
                        List arr = historys.split(','); //['efe','ef'],

                        if (arr.indexOf(controller.text) < 0) {
                          arr.add(controller.text);
                        }
                        var res = arr.join(',');

                        setState(() {
                          historys = res;
                        });
                        setItem('historys', res);
                        Navigator.pushNamed(context, '/result',
                            arguments: controller.text);
                      }
                    },
                  ),
                  fillColor: themeColor,
                  focusColor: themeColor,
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 17),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: Row(
                  children: <Widget>[
                    ...historylabels(historys.split(',').sublist(1))
                  ],
                ),
              ),
              FlatButton(
                shape: circle(5.0),
                padding: EdgeInsets.all(15),
                onPressed: () {
                  alert(context, '提示', '确定清除搜索历史吗', () {
                    removeItem('historys');
                    setState(() {
                      historys = '';
                    });
                    Navigator.pop(context);
                    toast('已清空搜索记录', context);
                  });
                },
                child: Text(
                  "清空搜索历史",
                  style: TextStyle(color: themeColor),
                ),
              ),
            ],
          ),
        ));
  }
}
