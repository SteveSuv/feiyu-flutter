import 'package:app/components/components.dart';
import 'package:flutter/material.dart';
import 'package:app/components/global.dart';

class Me extends StatefulWidget {
  Me({this.arg});
  final arg;
  @override
  State<StatefulWidget> createState() {
    return MeState();
  }
}

class MeState extends State<Me> {
  bool switchvalue = adshow;

  zonecard() {
    
      return Card(
          shape: circle(10.0),
          clipBehavior: Clip.hardEdge,
          elevation: 1,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: ListTile(
            trailing: Icon(Icons.keyboard_arrow_right),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: avatar(context, '', useravatar,false),
            title: Text(username),
            subtitle: Text('飞羽号:${userid}'),
            onTap: () {
              Navigator.pushNamed(context, '/zone', arguments: username);
            },
          ));
    } 

  picktheme(context) {
    var themes = [
      {'title': '默认绿', 'color': 4279213400},
      {'title': '深海蓝', 'color': 4279592384},
      {'title': '夏日橙', 'color': 4294940672},
      {'title': '烈焰红', 'color': 4294198070},
      {'title': '少女粉', 'color': 4293943954},
      {'title': '星空紫', 'color': 4289415100},
      {'title': '水鸭青', 'color': 4280723098},
    ];
    List<Widget> arr = [];
    for (var i = 0; i < themes.length; i++) {
      arr.add(Column(
        children: <Widget>[
          SimpleDialogOption(
            child: ListTile(
              dense: true,
              leading: Icon(
                Icons.lens,
                color: Color(themes[i]['color']),
                size: 25,
              ),
              title: Text(
                themes[i]['title'],
                style: TextStyle(fontSize: 15),
              ),
            ),
            onPressed: () {
              setState(() {
                themeColor = Color(themes[i]['color']);
                setItem('themeColor', themes[i]['color'].toString());
                toast("设置主题成功", context);
                RestartWidget.restartApp(context);
              });
            },
          ),
          Divider(
            height: 0,
          )
        ],
      ));
    }
    return arr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: themeColor,
          title: Text('我的'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () => Navigator.pushNamed(context, '/search')),
          ],
        ),
        body: ListView(
          children: <Widget>[
            zonecard(),
            Card(
              shape: circle(10.0),
              clipBehavior: Clip.hardEdge,
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.color_lens,
                      color: Colors.pink,
                    ),
                    title: Text('主题选择'),
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
                                      children: <Widget>[...picktheme(context)],
                                    ))
                              ]);
                        },
                      );
                    },
                  ),
                 
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.cyan,
                    ),
                    title: Text('账号设置'),
                    onTap: () {
                      Navigator.pushNamed(context, '/account');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.blueGrey,
                    ),
                    title: Text('系统设置'),
                    onTap: () {
                      Navigator.pushNamed(context, '/setting');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.feedback,
                      color: Colors.teal,
                    ),
                    title: Text('发送反馈'),
                    onTap: () {
                      Navigator.pushNamed(context, '/feedback_edit');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: Text('清空缓存'),
                    onTap: () {
                      alert(context, '确定清空应用缓存吗',
                          '这将会使你的应用恢复到初次打开时的状态,但你的任何数据都不会丢失', () {
                        clearall();
                        toast("已清空缓存", context);
                        RestartWidget.restartApp(context);
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.refresh,
                      color: Colors.brown,
                    ),
                    title: Text('检查更新'),
                    onTap: () async {
                      toast('暂无更新', context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.help,
                      color: Colors.purple,
                    ),
                    title: Text('关于'),
                    onTap: () {
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
