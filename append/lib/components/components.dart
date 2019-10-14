import 'package:app/components/api.dart';
import 'package:app/components/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';


// -----------------------------------重启app-----------------------------
class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
        context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}

// ------公共----------------------------------------------------------------------------------
// endline
Widget endline() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 40),
    child: Center(
      child: Text(
        '- 到底了哦，上拉试试 -',
        style: TextStyle(fontSize: 12, color: Colors.black12),
      ),
    ),
  );
}

Widget tiptext(String text) {
  return Center(
    child: Padding(
      padding: EdgeInsets.only(top: 10, bottom: 15),
      child: Text(
        '$text',
        style: TextStyle(fontSize: 12, color: Colors.black12),
      ),
    ),
  );
}

// 水波卡片
Widget ripplecard(child, [ontap]) {
  return Material(
    child: Card(
      elevation: 0,
      child: InkWell(onTap: ontap, child: child),
    ),
  );
}

// 水波卡片数组
List cardlist(context, args, route, child) {
  var arr = <Widget>[];
  for (var i = 0; i < args.length; i++) {
    var singlecard = ripplecard(child(context, args[i]), () {
      Navigator.pushNamed(context, route, arguments: args[i]);
    });
    arr.add(singlecard);
  }
  return arr;
}

//水波卡片listview
Widget cardlistview(context, args, route, child) {
  return ListView(
    children: <Widget>[...cardlist(context, args, route, child), endline()],
  );
}

// OutlineButton
class OutlineBtn extends StatelessWidget {
  Widget child;
  Function onPressed;
  ShapeBorder shape = circle(3.0);

  OutlineBtn({Key key, this.child, this.onPressed, this.shape})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      shape: shape,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.all(0),
      borderSide: BorderSide(color: Colors.transparent),
      highlightedBorderColor: Colors.transparent,
      child: child,
      onPressed: onPressed,
    );
  }
}

// 图片预览
Widget pressimg(args, index, callback) {
  return OutlineBtn(
    child: (args[index] is String)
        ? SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: lazyimage(args[index]))
        : SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.file(
              args[index],
              fit: BoxFit.cover,
            ),
          ),
    onPressed: () {
      callback(index);
    },
  );
}

// 图片网格
Widget pics(List args, [Function callback]) {
  return GridView.builder(
    padding: EdgeInsets.all(0),
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
    ),
    itemCount: args.length >= 9 ? 9 : args.length,
    itemBuilder: (context, index) {
      return pressimg(args, index, callback);
    },
  );
}

// avatarlisttile
Widget avatar(context, arguments, String image, [bool enable = true]) {
  return SizedBox(
    width: 40,
    child: OutlineBtn(
      shape: circle(200.0),
      onPressed: (enable == true)
          ? () {
              Navigator.pushNamed(context, '/zone', arguments: arguments);
            }
          : () {},
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 20,
        child: lazyimage(image),
      ),
    ),
  );
}

// lazyloadimg
lazyimage(String image) {
  return CachedNetworkImage(
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    ),
    imageUrl: image,
    placeholder: (context, url) => Stack(
      children: <Widget>[
        Image.asset(
          'assets/lazy.jpg',
          colorBlendMode: BlendMode.darken,
        ),
        Positioned(
          child: Center(
            child: Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                ))),
          ),
        )
      ],
    ),
    errorWidget: (context, url, error) => Icon(
      Icons.error,
      color: Colors.red,
      size: 30,
    ),
  );
}

// 首页卡片
Widget carditem(context, arg, String table,
    [String child,
    bool author = true,
    bool title = true,
    bool content = true,
    bool picshow = true,
    bool chip = true,
    bool footer = true]) {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: <Widget>[
            Container(
                child: (author == true)
                    ? Row(
                        children: <Widget>[
                          Flexible(
                              child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            leading: avatar(
                                context,
                                arg['${table}_author']['name'],
                                arg['${table}_author']['avatar']),
                            title: Text(
                              arg['${table}_author']['name'],
                            ),
                            subtitle: Text(
                              arg['${table}_showtime'],
                              style: TextStyle(color: Colors.grey),
                            ),
                          ))
                        ],
                      )
                    : null),
            Container(
                child: (title == true)
                    ? Row(
                        children: <Widget>[
                          Flexible(
                              child: Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              arg['${table}_title'],
                              style: TextStyle(
                                fontSize: 18.0,
                                color: themeColor,
                                fontWeight: FontWeight.w600,
                              ),
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                        ],
                      )
                    : null),
            Container(
                child: (content == true)
                    ? Row(
                        children: <Widget>[
                          Flexible(
                              child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              arg['${table}_content'],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                            ),
                          ))
                        ],
                      )
                    : null),
            Container(
                child: (picshow == true)
                    ? Container(
                        child: (arg['${table}_images'].length == 0)
                            ? null
                            : Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: pics(arg['${table}_images'], (e) {
                                  Navigator.pushNamed(context, '/imgdialog',
                                      arguments: [arg['${table}_images'], e]);
                                }),
                              ),
                      )
                    : null),
            Container(
              child: (chip != true ||
                      arg['${table}_label'] == null ||
                      arg['${table}_label'] == 'null' ||
                      arg['${table}_label'] == '' ||
                      !(arg['${table}_label'] is String))
                  ? null
                  : SizedBox(
                      height: 35,
                      child: Row(
                        children: <Widget>[
                          Transform(
                              transform: Matrix4.identity()..scale(0.8),
                              child: ActionChip(
                                pressElevation: 0,
                                shape: circle(5.0),
                                label: Text(
                                  arg['${table}_label'],
                                  style: TextStyle(color: themeColor),
                                ),
                                backgroundColor: themeColor.withOpacity(0.1),
                                onPressed: () async {
                                  var data = await api_getdata('course',
                                      {'course_title': arg['${table}_label']});
                                  Navigator.pushNamed(context, '/course_detail',
                                      arguments: data[0]);
                                },
                              )),
                        ],
                      )),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Container(
                    child: (footer == true)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                                Flexible(
                                  child: Text(
                                    '已有${arg['${table}_see']}人查看',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                                Flexible(
                                    child: Text(
                                  '$child',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.grey),
                                )),
                              ])
                        : null))
          ],
        ),
      )
    ],
  );
}

//详情页卡片
Widget carddetailitem(context, arg, String table,
    [String child,
    bool author = true,
    bool title = true,
    bool content = true,
    bool picshow = true,
    bool chip = true,
    bool footer = true]) {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: <Widget>[
            Container(
                child: (author == true)
                    ? Row(
                        children: <Widget>[
                          Flexible(
                              child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            leading: avatar(
                                context,
                                arg['${table}_author']['name'],
                                arg['${table}_author']['avatar']),
                            title: Text(
                              arg['${table}_author']['name'],
                            ),
                            subtitle: Text(arg['${table}_showtime'],
                                style: TextStyle(color: Colors.grey)),
                          ))
                        ],
                      )
                    : null),
            Container(
                child: (title == true)
                    ? Row(
                        children: <Widget>[
                          Flexible(
                              child: Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(arg['${table}_title'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: themeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                softWrap: true),
                          ))
                        ],
                      )
                    : null),
            Container(
                child: (content == true)
                    ? Row(
                        children: <Widget>[
                          Flexible(
                              child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              arg['${table}_content'],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              softWrap: true,
                            ),
                          ))
                        ],
                      )
                    : null),
            Container(
                child: (picshow == true)
                    ? Container(
                        child: (arg['${table}_images'].length == 0)
                            ? null
                            : Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: pics(arg['${table}_images'], (e) {
                                  Navigator.pushNamed(context, '/imgdialog',
                                      arguments: [arg['${table}_images'], e]);
                                }),
                              ),
                      )
                    : null),
            Container(
              child: (chip != true ||
                      arg['${table}_label'] == null ||
                      arg['${table}_label'] == 'null' ||
                      arg['${table}_label'] == '' ||
                      !(arg['${table}_label'] is String))
                  ? null
                  : SizedBox(
                      height: 35,
                      child: Row(
                        children: <Widget>[
                          Transform(
                              transform: Matrix4.identity()..scale(0.8),
                              child: ActionChip(
                                pressElevation: 0,
                                shape: circle(5.0),
                                label: Text(
                                  arg['${table}_label'],
                                  style: TextStyle(color: themeColor),
                                ),
                                backgroundColor: themeColor.withOpacity(0.1),
                                onPressed: () async {
                                  var data = await api_getdata('course',
                                      {'course_title': arg['${table}_label']});
                                  Navigator.pushNamed(context, '/course_detail',
                                      arguments: data[0]);
                                },
                              )),
                        ],
                      )),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Container(
                    child: (footer == true)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                                Flexible(
                                  child: Text(
                                    '已有${arg['${table}_see']}人查看',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                                Flexible(
                                    child: Text(
                                  '$child',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.grey),
                                )),
                              ])
                        : null))
          ],
        ),
      )
    ],
  );
}

// ------动态----------------------------------------------------------------------------------

// 首页动态
Widget topicitem(context, arg) {
  return carditem(context, arg, 'topic',
      '${arg['topic_up']}人点赞 · ${arg['topic_comment'].length}条回复');
}

// 动态详情
Widget topicdetailitem(context, arg) {
  return carddetailitem(
    context,
    arg,
    'topic',
    '${arg['topic_up']}人点赞 · ${arg['topic_comment'].length}条回复',
  );
}

// ------课程----------------------------------------------------------------------------------
coursesarr(args, context) {
  var arr = [];
  for (var index = 0; index < args.length; index++) {
    arr.add(Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundColor: themeColor,
            child: Text(
              args[index]['course_title'][0],
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            args[index]['course_title'],
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(args[index]['course_content'],
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey)),
          trailing: Text(
            '${double.parse(args[index]['course_mark'].toString()).toStringAsFixed(1)}',
            style: TextStyle(color: themeColor),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/course_detail',
                arguments: args[index]);
          },
        ),
        // Divider(height: 0),
      ],
    ));
  }
  return arr;
}

// 课程列表
Widget courselist(args, context) {
  return ListView(children: [...coursesarr(args, context), endline()]);
}

filesarr(args, context) {
  var arr = [];
  for (var index = 0; index < args.length; index++) {
    arr.add(Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundColor: themeColor,
            child: Text(
              args[index]['file_title'][0],
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(args[index]['file_title'], softWrap: false),
          subtitle: Text('发布于${args[index]['file_showtime']}',
              style: TextStyle(color: Colors.grey)),
          trailing: Text(
            '${double.parse(args[index]['file_mark'].toString()).toStringAsFixed(1)}',
            style: TextStyle(color: themeColor),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/file_detail',
                arguments: args[index]);
          },
        ),
        // Divider(height: 0),
      ],
    ));
  }
  return arr;
}

// 资料列表
Widget filelist(args, context) {
  return ListView(children: [...filesarr(args, context), endline()]);
}

// 资料详情
Widget filedetailitem(context, arg) {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                    child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: avatar(context, arg['file_author']['name'],
                      arg['file_author']['avatar']),
                  title: Text(
                    arg['file_author']['name'],
                  ),
                  subtitle: Text(arg['file_showtime'],
                      style: TextStyle(color: Colors.grey)),
                ))
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: ButtonTheme(
                          height: 50,
                          shape: circle(5.0),
                          buttonColor: themeColor.withOpacity(0.1),
                          child: RaisedButton(
                            highlightElevation: 0,
                            elevation: 0,
                            padding: EdgeInsets.all(10),
                            onPressed: () {
                              alert(context, '提示', '确认下载此文件吗', () {
                                // setState(() {
                                //   ...;
                                // });
                                Navigator.pop(context);
                                toast('开始下载文件...', context);
                              });
                            },
                            child: Text(
                              '文件名称：${arg['file_title']}\n文件大小：${arg['file_size']}',
                              softWrap: true,
                              style: TextStyle(color: themeColor),
                            ),
                          ),
                        ))),
              ],
            ),
            SizedBox(
                height: 35,
                child: Row(
                  children: <Widget>[
                    Transform(
                        transform: Matrix4.identity()..scale(0.8),
                        child: ActionChip(
                          pressElevation: 0,
                          shape: circle(5.0),
                          label: Text(
                            arg['file_label'],
                            style: TextStyle(color: themeColor),
                          ),
                          backgroundColor: themeColor.withOpacity(0.1),
                          onPressed: () async {
                            var data = await api_getdata(
                                'course', {'course_title': arg['file_label']});
                            Navigator.pushNamed(context, '/course_detail',
                                arguments: data[0]);
                          },
                        )),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          '已有${arg['file_see']}人查看',
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                      ),
                      Flexible(
                          child: Text(
                        '${arg['file_up']}人点赞 · ${arg['file_comment'].length}条回复',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      )),
                    ]))
          ],
        ),
      )
    ],
  );
}

// 课程详情
Widget coursedetailitem(context, arg) {
  return ripplecard(Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                      child: RaisedButton(
                    color: themeColor,
                    shape: circle(5.0),
                    child: Text(
                      '${arg['course_title']} / ${double.parse(arg['course_mark'].toString()).toStringAsFixed(1)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    highlightElevation: 0,
                    elevation: 0,
                    onPressed: () {
                      toast('弹出评分卡', context);
                    },
                  )),
                  Flexible(
                      child: RaisedButton(
                    textColor: themeColor,
                    color: themeColor.withOpacity(0.1),
                    shape: circle(5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.add),
                        SizedBox(
                          width: 5,
                        ),
                        Text('收藏')
                      ],
                    ),
                    highlightElevation: 0,
                    elevation: 0,
                    onPressed: () {
                      toast('加入收藏', context);
                      // .................
                    },
                  )),
                ],
              )),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              '${arg['course_content']}',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
              ),
              softWrap: true,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        '已有${arg['course_see']}人查看',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ),
                    Flexible(
                        child: Text(
                      '${arg['course_comment'].length}条评论',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    )),
                  ]))
        ],
      )));
}

// ------消息-------------------------------------------------------------------------------
msgsarr(args, context) {
  var arr = [];
  for (var index = 0; index < args.length; index++) {
    arr.add(Column(
      children: <Widget>[
        ListTile(
          leading: avatar(context, args[index]['msg_author']['name'],
              args[index]['msg_author']['avatar']),
          title: Text(
            args[index]['msg_author']['name'],
          ),
          subtitle: Text(args[index]['msg_author']['content'],
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey)),
          trailing: Text(
            args[index]['msg_showtime'],
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () {
            Navigator.pushNamed(context, args[index]['msg_route'],
                arguments: args[index]);
          },
        ),
        // Divider(height: 0,)
      ],
    ));
  }
  return arr;
}

Widget msglist(args, context) {
  return ListView(children: [...msgsarr(args, context), endline()]);
}

// ------我的----------------------------------------------------------------------------

// ------评论----------------------------------------------------------------------------------

// 改为class
// 单个评论
Widget onecomment(context, arg) {
  return Column(
    children: <Widget>[
      ListTile(
          dense: true,
          leading: avatar(context, arg['comment_author']['name'],
              arg['comment_author']['avatar']),
          onTap: () {
            Navigator.pushNamed(context, '/comment_detail', arguments: arg);
          },
          onLongPress: () {
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
                                    Icons.reply,
                                    color: themeColor,
                                    size: 25,
                                  ),
                                  title: Text(
                                    '回复评论',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/comment_edit',
                                      arguments: [
                                        arg['comment_label'],
                                        arg['comment_pid'],
                                        '回复' + arg['comment_author']['name'],
                                        arg['comment_author']['name'],
                                      ]);
                                },
                              ),
                              Divider(
                                height: 0,
                              ),
                              SimpleDialogOption(
                                child: ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.content_copy,
                                    color: themeColor,
                                    size: 25,
                                  ),
                                  title: Text(
                                    '复制评论',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await Clipboard.setData(ClipboardData(
                                      text: '${arg['comment_content']}'));
                                  toast('已复制到剪贴板', context);
                                },
                              ),
                            ],
                          ))
                    ]);
              },
            );
          },
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                arg['comment_author']['name'],
                style: TextStyle(color: themeColor, fontSize: 15),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                arg['comment_content'],
                style: TextStyle(fontSize: 15, color: Colors.black87),
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: (arg['comment_images'].length == 0)
                    ? null
                    : Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: pics(arg['comment_images'], (e) {
                          Navigator.pushNamed(context, '/imgdialog',
                              arguments: [arg['comment_images'], e]);
                        }),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    arg['comment_showtime'],
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '${arg['comment_up']}人点赞 · 29条回复',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )),
      // Divider(
      //   height: 0,
      // ),
    ],
  );
}

// 单个评论详情
Widget commentdetail(context, arg) {
  return ListTile(
    dense: true,
    leading: avatar(context, arg['comment_author']['name'],
        arg['comment_author']['avatar']),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Text(
          arg['comment_author']['name'],
          style: TextStyle(color: themeColor, fontSize: 15),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          arg['comment_content'],
          style: TextStyle(fontSize: 15, color: Colors.black87),
          softWrap: true,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: (arg['comment_images'].length == 0)
              ? null
              : Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: pics(arg['comment_images'], (e) {
                    Navigator.pushNamed(context, '/imgdialog',
                        arguments: [arg['comment_images'], e]);
                  }),
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              arg['comment_showtime'],
              style: TextStyle(fontSize: 13),
            ),
            Text(
              '${arg['comment_up']}人点赞 · 29条回复',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}

// 一组评论
List commentslist(context, args) {
  var arr = <Widget>[];
  for (var i = 0; i < args.length; i++) {
    arr.add(onecomment(context, args[i]));
  }
  arr.add(endline());
  return arr;
}

// 评论框
Widget commentinput(context, List arg) {
  return ripplecard(
      TextField(
        enabled: false,
        scrollPadding: EdgeInsets.all(10),
        cursorColor: themeColor,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            OMIcons.edit,
            color: themeColor,
            size: 20,
          ),
          hintText: "发表评论",
          border: InputBorder.none, //输入边框设为null
        ),
      ), () {
    Navigator.pushNamed(context, '/comment_edit', arguments: arg);
  });
}

// ------其他----------------------------------------------------------------------------------

Widget flatbtn(color, icon, data) {
  return FlatButton(
    highlightColor: color.withOpacity(0.3),
    onPressed: () {},
    child: Row(
      children: <Widget>[
        Icon(
          icon,
          color: color,
          size: 15,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          data,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        )
      ],
    ),
  );
}

//详情页菜单
class Shareicon extends StatelessWidget {
  Shareicon({Key key, this.arg}) : super(key: key);

  var arg;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () {
        share('$arg\n\n下载飞羽APP($domain),发现更多精彩内容');
      },
    );
  }
}

// 登录按钮
Widget loginbtn(context) {
  return Center(
    child: RaisedButton(
      elevation: 0,
      highlightElevation: 0,
      child: Text(
        '登录/注册',
        style: TextStyle(color: Colors.white),
      ),
      color: themeColor,
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
    ),
  );
}

// 数据为空
Widget nodata() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Image.asset(
        'assets/nodata.png',
        scale: 2,
      ),
      Text('没有找到相关数据哦', style: TextStyle(color: Colors.grey))
    ],
  ));
}

// 评论为空
Widget nocomment() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        height: 50,
      ),
      Image.asset(
        'assets/nodata.png',
        scale: 3,
      ),
      Text('还没有人评论哦', style: TextStyle(color: Colors.grey))
    ],
  ));
}

// 弹出框
alert(context, title, content, callback) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: circle(10.0),
        title: Text(title),
        content: Text(
          content,
          style: TextStyle(color: Colors.grey),
        ),
        actions: <Widget>[
          FlatButton(
            highlightColor: Colors.white,
            child: Text(
              '确认',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            onPressed: callback,
          ),
          FlatButton(
            highlightColor: Colors.white,
            child: Text(
              '取消',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

// loading
loading(context, [value]) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        backgroundColor: Colors.white,
        shape: circle(10.0),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                  child: CircularProgressIndicator(
                value: value,
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              )))
        ],
      );
    },
  );
}

// 页面加载
Widget pageload() {
  return Center(
    child: CircularProgressIndicator(
      strokeWidth: 3.0,
      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
    ),
  );
}

// 刷新
class Refresh extends StatelessWidget {
  Widget child;
  bool enablePullDown; //下拉刷新
  bool enablePullUp; //上拉加载
  Function headercallback;
  Function footercallback;
  Refresh(
      {Key key,
      this.child,
      this.enablePullDown = true,
      this.enablePullUp = true,
      this.headercallback,
      this.footercallback})
      : super(key: key);
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 300));
    await headercallback();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    await Future.delayed(Duration(milliseconds: 300));
    await footercallback();
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: enablePullDown,
        enablePullUp: enablePullUp,
        header: MaterialClassicHeader(
          color: themeColor,
        ),
        footer: ClassicFooter(
          textStyle: TextStyle(color: themeColor),
          idleText: '加载更多',
          idleIcon: Icon(
            Icons.arrow_upward,
            color: themeColor,
          ),
          loadingIcon: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
            ),
          ),
          loadingText: '',
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: child);
  }
}

// imgpick
imgpick(context, func) {
  return showDialog(
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
                          Icons.photo_camera,
                          color: themeColor,
                          size: 25,
                        ),
                        title: Text(
                          "从拍照获取",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      onPressed: () async {
                        var imageFile = await ImagePicker.pickImage(
                            source: ImageSource.camera);
                        await func([imageFile]);
                        Navigator.pop(context);
                      },
                    ),
                    Divider(
                      height: 0,
                    ),
                    SimpleDialogOption(
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.photo_library,
                          color: themeColor,
                          size: 25,
                        ),
                        title: Text(
                          "从相册获取",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      onPressed: () async {
                        List<File> imageFiles = [];
                        imageFiles = await FilePicker.getMultiFile(
                            type: FileType.IMAGE); //就是arr
                        await func(imageFiles);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ))
          ]);
    },
  );
}

// label textfield
labelfield(arg) {
  return Container(
    child: (arg == null)
        ? null
        : Column(
            children: <Widget>[
              TextFormField(
                enabled: false,
                cursorColor: themeColor,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '$arg',
                    hintStyle: TextStyle(color: themeColor)),
              ),
              Divider(
                height: 0,
              ),
            ],
          ),
  );
}
