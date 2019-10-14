import 'package:app/components/global.dart';
import 'package:app/components/components.dart';
import 'package:flutter/material.dart';
import 'package:app/components/api.dart';

class FileDetail extends StatefulWidget {
  final arg;
  FileDetail({this.arg});

  State<StatefulWidget> createState() {
    return FileDetailState(arg: this.arg);
  }
}

class FileDetailState extends State<FileDetail> {
  var arg;
  FileDetailState({this.arg});
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

      var resp = await api_getpage('file', arg['_id'], username);
      var comments = await api_getdata(
          'comment',
          {
            'comment_pid': arg['_id'],
            'comment_label': 'file',
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
            filedetailitem(context, arg),
      
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
            'comment_label': 'file',
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
            filedetailitem(context, arg),

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
              title: Text('资料详情'),
              actions: <Widget>[
                Shareicon(
                    arg: '${arg['file_author']['name']}:${arg['file_title']}')
              ],
            ),
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
                    child: commentinput(
                        context, ['file', arg['_id'], arg['file_title']]))
              ],
            )));
  }
}
