import 'package:app/components/api.dart';
import 'package:flutter/material.dart';
import 'package:app/components/global.dart';
import 'package:flutter/widgets.dart';
import 'package:app/components/components.dart';

class CourseDetail extends StatefulWidget {
  CourseDetail({this.arg});
  final arg;
  State<StatefulWidget> createState() {
    return CourseDetailState(arg: this.arg);
  }
}

class CourseDetailState extends State<CourseDetail>
    with TickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  var arg;
  CourseDetailState({this.arg});

  var tabs = [
    Tab(
      text: "主页",
    ),
    Tab(
      text: "资料",
    ),
    Tab(
      text: "动态",
    ),
  ];

  var tab1 = pageload();
  var tab2 = pageload();
  var tab3 = pageload();

  var hasresp1 = false;
  var hasresp2 = false;
  var hasresp3 = false;

  var limit1 = 20;
  var index1 = 0;
  var skip1 = 0;

  var limit2 = 20;
  var index2 = 0;
  var skip2 = 0;

  var limit3 = 20;
  var index3 = 0;
  var skip3 = 0;

  var course = {};
  var comments = [];
  var files = [];
  var topics = [];

  void resp1header() async {
    if (hasresp1 == false) {
      var resp = await api_getpage('course', arg['_id'], username);
      comments = await api_getdata(
          'comment',
          {
            'comment_pid': arg['_id'],
            'comment_label': 'course',
            'comment_to': 'root'
          },
          '-sendtime');
      setState(() {
        arg = resp;
        tab1 = (resp == null) ? nodata() : courseinfo();
        hasresp1 = true;
      });
    }
  }

  void resp2header() async {
    if (hasresp2 == false) {
      limit2 = 20;
      index2 = 0;
      skip2 = 0;
      files = await api_getdata('file', {'file_label': arg['course_title']},
          '-sendtime', skip2, limit2);
      setState(() {
        tab2 = (files.length == 0) ? nodata() : filelist(files, context);
        hasresp2 = true;
      });
    }
  }

  void resp2footer() async {
    if (hasresp2 == false) {
      index2++;
      skip2 = index2 * limit2;
      List newfiles = await api_getdata('file',
          {'file_label': arg['course_title']}, '-sendtime', skip2, limit2);
      files.addAll(newfiles);
      setState(() {
        tab2 = (files.length == 0) ? nodata() : filelist(files, context);
        hasresp2 = true;
      });
    }
  }

  // --------------------------------

  void resp3header() async {
    if (hasresp3 == false) {
      limit3 = 20;
      index3 = 0;
      skip3 = 0;
      topics = await api_getdata('topic', {'topic_label': arg['course_title']},
          '-sendtime', skip3, limit3);
      setState(() {
        tab3 = (topics.length == 0)
            ? nodata()
            : cardlistview(context, topics, '/topic_detail', topicitem);
        hasresp3 = true;
      });
    }
  }

  void resp3footer() async {
    if (hasresp3 == false) {
      index3++;
      skip3 = index3 * limit3;
      List newtopics = await api_getdata('topic',
          {'topic_label': arg['course_title']}, '-sendtime', skip3, limit3);
      topics.addAll(newtopics);
      setState(() {
        tab3 = (topics.length == 0)
            ? nodata()
            : cardlistview(context, topics, '/topic_detail', topicitem);
        hasresp3 = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _tabController = TabController(vsync: this, length: tabs.length)
      ..addListener(() {
        setState(() {});
      });
    resp1header();
    resp2header();
    resp3header();
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  _bottomButtons() {
    if (_tabController.index == 0) {
      return null;
    }
    if (_tabController.index == 1) {
      return FloatingActionButton(
          heroTag: null,
          onPressed: () {
            Navigator.pushNamed(context, '/file_edit',
                arguments: arg['course_title']);
          },
          backgroundColor: themeColor,
          child: Icon(Icons.file_upload));
    }
    if (_tabController.index == 2) {
      return FloatingActionButton(
          heroTag: null,
          onPressed: () {
            Navigator.pushNamed(context, '/topic_edit',
                arguments: arg['course_title']);
          },
          backgroundColor: themeColor,
          child: Icon(Icons.edit));
    }
  }

  commentarea() {
    if (comments.length == 0) {
      return [nocomment()];
    } else {
      return commentslist(context, comments);
    }
  }

  courseinfo() {
    return ListView(
      children: <Widget>[coursedetailitem(context, arg), ...commentarea()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              backgroundColor: themeColor,
              title: Text('课程详情'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => Navigator.pushNamed(context, '/search')),
              ],
              pinned: true,
              floating: true,
              bottom: TabBar(
                unselectedLabelColor: Colors.white.withOpacity(0.4),
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: tabs,
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Refresh(
                  child: tab1,
                  headercallback: () {
                    hasresp1 = false;
                    resp1header();
                  },
                  footercallback: () {},
                ),
                Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: commentinput(
                        context, ['course', arg['_id'], arg['course_title']]))
              ],
            ),
            Refresh(
              child: tab2,
              headercallback: () {
                hasresp2 = false;
                resp2header();
              },
              footercallback: () {
                hasresp2 = false;
                resp2footer();
              },
            ),
            Refresh(
              child: tab3,
              headercallback: () {
                hasresp3 = false;
                resp3header();
              },
              footercallback: () {
                hasresp3 = false;
                resp3footer();
              },
            ),
          ],
          controller: _tabController,
        ),
      ),
      floatingActionButton: _bottomButtons(),
    );
  }
}
