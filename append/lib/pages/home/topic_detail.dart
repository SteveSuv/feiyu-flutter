import 'package:app/components/global.dart';
import 'package:app/components/components.dart';
import 'package:flutter/material.dart';
import 'package:app/components/api.dart';

class TopicDetail extends StatefulWidget {
  final arg;
  TopicDetail({this.arg});

  State<StatefulWidget> createState() {
    return TopicDetailState(arg: this.arg);
  }
}

class TopicDetailState extends State<TopicDetail> {
  var arg;
  TopicDetailState({this.arg});
  var tab1 = pageload();

  List comments;

  var limit1 = 20;
  var index1 = 0;
  var skip1 = 0;

  var hasresp1 = false;

  resp1header() async {
    if (hasresp1 == false) {
      limit1 = 20;
      index1 = 0;
      skip1 = 0;
      var resp = await api_getpage('topic', arg['_id'], username);
      comments = await api_getdata(
          'comment',
          {
            'comment_pid': arg['_id'],
            'comment_label': 'topic',
            'comment_to': 'root'
          },
          '-sendtime',
          skip1,
          limit1);
      var commentarea = (comments.length == 0)
          ? [nocomment()]
          : commentslist(context, comments);
      setState(() {
        arg = resp;
        tab1 = ListView(
          padding: EdgeInsets.only(bottom: 50),
          children: <Widget>[
            topicdetailitem(context, arg),

            ...commentarea
          ],
        );

        hasresp1 = true;
      });
    }
  }

  resp1footer() async {
    if (hasresp1 == false) {
      index1++;
      skip1 = index1 * limit1;
      var newcomments = await api_getdata(
          'comment',
          {
            'comment_pid': arg['_id'],
            'comment_label': 'topic',
            'comment_to': 'root'
          },
          '-sendtime',
          skip1,
          limit1);
      comments.addAll(newcomments);
      var commentarea = (comments.length == 0)
          ? [nocomment()]
          : commentslist(context, comments);

      setState(() {
        tab1 = ListView(
          padding: EdgeInsets.only(bottom: 50),
          children: <Widget>[
            topicdetailitem(context, arg),

            ...commentarea
          ],
        );
        hasresp1 = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    resp1header();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                elevation: 0,
                backgroundColor: themeColor,
                title: Text('动态详情'),
                actions: <Widget>[
                  Shareicon(
                      arg:
                          '${arg['topic_author']['name']}:${arg['topic_title']}')
                ]),
            body: Stack(
              children: <Widget>[
                Refresh(
                  child: tab1,
                  headercallback: () {
                    hasresp1 = false;
                    resp1header();
                  },
                  footercallback: () {
                    hasresp1 = false;
                    resp1footer();
                  },
                ),
                Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: commentinput(context, [
                      'topic',
                      arg['_id'],
                      arg['topic_author']['name'] + '的动态'
                    ]))
              ],
            )));
  }
}
