import 'package:app/components/components.dart';
import 'package:app/components/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';

class About extends StatelessWidget {
  About({this.arg});
  final arg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: themeColor,
          title: Text('关于'),
        ),
        body: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.info, color: themeColor),
              title: Text('应用介绍'),
              subtitle: Text('飞羽'),
              onTap: () {
                alert(context, '应用介绍',
                    '飞羽是一款以课程为核心的APP,独立各个学校的内容池进行内容分发,集成论坛发帖，课程评价，资料分享等众多功能，是独立第三方的校园内容生态圈。',
                    () {
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.code, color: themeColor),
              title: Text('开发故事'),
              subtitle: Text('开发初衷及起源'),
              onTap: () {
                alert(context, '开发故事',
                    '应用完全采用谷歌Flutter框架和MD设计理念开发，应用独立于学校等各机构之外，由作者独立开发运营，故难免会有瑕疵，如大家遇到相关问题请及时反馈。',
                    () {
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.web, color: themeColor),
              title: Text('前往官网'),
              subtitle: Text('查看官方网站'),
              onTap: () {
                urllaunch('$domain');
              },
            ),
            ListTile(
              leading: Icon(Icons.chat, color: themeColor),
              title: Text('加入QQ群'),
              subtitle: Text('应用官方交流群'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                        shape: circle(10.0),
                        contentPadding: EdgeInsets.all(0),
                        titlePadding: EdgeInsets.all(0),
                        children: <Widget>[
                          Card(
                              margin: EdgeInsets.all(0),
                              shape: circle(10.0),
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                children: <Widget>[
                                  SimpleDialogOption(
                                    child: ListTile(
                                      dense: true,
                                      leading: Icon(
                                        Icons.group_add,
                                        color: themeColor,
                                        size: 25,
                                      ),
                                      title: Text(
                                        '一群 584236247',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await Clipboard.setData(
                                          ClipboardData(text: '584236247'));
                                      toast('已复制群号', context);
                                    },
                                  ),
                                  Divider(
                                    height: 0,
                                  ),
                                  SimpleDialogOption(
                                    child: ListTile(
                                      dense: true,
                                      leading: Icon(
                                        Icons.group_add,
                                        color: themeColor,
                                        size: 25,
                                      ),
                                      title: Text(
                                        '二群 624618329',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await Clipboard.setData(
                                          ClipboardData(text: '624618329'));
                                      toast('已复制群号', context);
                                    },
                                  ),
                                ],
                              ))
                        ]);
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.monetization_on, color: themeColor),
              title: Text('鼓励作者'),
              subtitle: Text('给辛苦的作者一点鼓励'),
              onTap: () {
                alert(context, '鼓励',
                    '此应用完全免费，唯一收入来源是卡片广告，以此来抵消服务器开销维持正常的运营，点击广告来鼓励一下作者吧。', () {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ));
  }
}
