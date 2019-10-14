import 'package:app/components/global.dart';
import 'package:app/components/components.dart';
import 'package:app/components/api.dart';
import 'package:flutter/material.dart';

class CommentDetail extends StatefulWidget {
  final arg;
  CommentDetail({this.arg});

  State<StatefulWidget> createState() {
    return CommentDetailState(arg: this.arg);
  }
}

class CommentDetailState extends State<CommentDetail> {
  final arg;
  CommentDetailState({this.arg});

  var tab1 = [
    SizedBox(
      height: 50,
    ),
    pageload(),
    SizedBox(
      height: 50,
    ),
  ];

  var hasresp = false;

  var comments = [];

  var limit = 20;
  var index = 0;
  var skip = 0;

  respheader() async {
    limit = 20;
    index = 0;
    skip = 0;
    if (hasresp == false) {
      comments = await api_getdata(
          'comment',
          {
            'comment_pid': arg['comment_pid'],
            'comment_label': arg['comment_label'],
            'comment_to': arg['comment_author']['name'],
          },
          '-sendtime',
          skip,
          limit);
      setState(() {
        hasresp = true;
        tab1 = (comments.length == 0)
            ? [nocomment()]
            : commentslist(context, comments);
      });
    }
  }

  void respfooter() async {
    if (hasresp == false) {
      index++;
      skip = index * limit;
      List newcomments = await api_getdata(
          'comment',
          {
            'comment_pid': arg['comment_pid'],
            'comment_label': arg['comment_label'],
            'comment_to': arg['comment_author']['name'],
          },
          '-sendtime',
          skip,
          limit);
      comments.addAll(newcomments);
      setState(() {
        hasresp = true;
        tab1 = (comments.length == 0)
            ? [nocomment()]
            : commentslist(context, comments);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    respheader();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                elevation: 0,
                backgroundColor: themeColor,
                title: Text('评论详情'),
                actions: <Widget>[
                  Shareicon(
                      arg:
                          '${arg['comment_author']['name']}:${arg['comment_content']}')
                ]),
            body: Stack(
              children: <Widget>[
                Refresh(
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 50),
                    children: <Widget>[
                      commentdetail(context, arg),
                      Divider(height: 0,),
                      ...tab1,
                    ],
                  ),
                  headercallback: () {
                    hasresp = false;
                    respheader();
                  },
                  footercallback: () {
                    hasresp = false;
                    respfooter();
                  },
                ),
                Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: commentinput(context, [
                      arg['comment_label'],
                      arg['comment_pid'],
                      '回复' + arg['comment_author']['name'],
                      arg['comment_author']['name'],
                    ]))
              ],
            )));
  }
}
