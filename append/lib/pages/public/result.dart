import 'package:app/components/api.dart';
import 'package:flutter/material.dart';
import 'package:app/components/global.dart';
import 'package:flutter/widgets.dart';
import 'package:app/components/components.dart';

class Result extends StatefulWidget {
  Result({this.arg});
  final arg; //name
  State<StatefulWidget> createState() {
    return ResultState(arg: this.arg);
  }
}

class ResultState extends State<Result> with TickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  var arg;
  ResultState({this.arg});

  var tabs = [
    Tab(
      text: "动态",
    ),
    Tab(
      text: "课程",
    ),
    Tab(
      text: "资料",
    ),
    Tab(
      text: "用户",
    ),
  ];

  var tab1 = pageload();
  var tab2 = pageload();
  var tab3 = pageload();
  var tab4 = pageload();

  var hasresp1 = false;
  var hasresp2 = false;
  var hasresp3 = false;
  var hasresp4 = false;

  var limit1 = 20;
  var index1 = 0;
  var skip1 = 0;

  var limit2 = 20;
  var index2 = 0;
  var skip2 = 0;

  var limit3 = 20;
  var index3 = 0;
  var skip3 = 0;

  var limit4 = 20;
  var index4 = 0;
  var skip4 = 0;

  var topics = [];

  var courses = [];

  var files = [];
  var users = [];

  void resp1header() async {
    if (hasresp1 == false) {
      limit1 = 20;
      index1 = 0;
      skip1 = 0;
      topics = await api_getdata(
          'topic', {'topic_author.name': arg}, '-sendtime', skip1, limit1);
      setState(() {
        tab1 = (topics.length == 0)
            ? nodata()
            : cardlistview(context, topics, '/topic_detail', topicitem);
        hasresp1 = true;
      });
    }
  }

  void resp1footer() async {
    if (hasresp1 == false) {
      index1++;
      skip1 = index1 * limit1;
      List newtopics = await api_getdata(
          'topic', {'topic_author.name': arg}, '-sendtime', skip1, limit1);
      topics.addAll(newtopics);
      setState(() {
        tab1 = (topics.length == 0)
            ? nodata()
            : cardlistview(context, topics, '/topic_detail', topicitem);
        hasresp1 = true;
      });
    }
  }

  void resp2header() async {
    if (hasresp2 == false) {
      limit2 = 20;
      index2 = 0;
      skip2 = 0;
      courses = await api_getdata(
          'course', {'course_author.name': arg}, '-sendtime', skip2, limit2);

      setState(() {
        tab2 = (courses.length == 0) ? nodata() : courselist(courses, context);
        hasresp2 = true;
      });
    }
  }

  void resp2footer() async {
    if (hasresp2 == false) {
      index2++;
      skip2 = index2 * limit2;
      List newcourses = await api_getdata(
          'course', {'course_author.name': arg}, '-sendtime', skip2, limit2);
      courses.addAll(newcourses);
      setState(() {
        tab2 = (courses.length == 0) ? nodata() : courselist(courses, context);
        hasresp2 = true;
      });
    }
  }

  void resp3header() async {
    if (hasresp3 == false) {
      limit3 = 20;
      index3 = 0;
      skip3 = 0;
      files = await api_getdata(
          'file', {'file_author.name': arg}, '-sendtime', skip3, limit3);
      setState(() {
        tab3 = (files.length == 0) ? nodata() : filelist(files, context);

        hasresp3 = true;
      });
    }
  }

  void resp3footer() async {
    if (hasresp3 == false) {
      index3++;
      skip3 = index3 * limit3;
      List newfiles = await api_getdata(
          'file', {'file_author.name': arg}, '-sendtime', skip3, limit3);
      files.addAll(newfiles);
      setState(() {
        tab3 = (files.length == 0) ? nodata() : filelist(files, context);
        hasresp3 = true;
      });
    }
  }

  void resp4header() async {
    if (hasresp4 == false) {
      limit4 = 20;
      index4 = 0;
      skip4 = 0;
      users = await api_getdata(
          'user', {'user_author.name': arg}, '-sendtime', skip4, limit4);
      setState(() {
        // tab4 = (users.length == 0) ? nodata() : userlist(users);
        tab4 = nodata();
        hasresp4 = true;
      });
    }
  }

  void resp4footer() async {
    if (hasresp4 == false) {
      index4++;
      skip4 = index4 * limit4;
      List newusers = await api_getdata(
          'user', {'user_author.name': arg}, '-sendtime', skip4, limit4);
      users.addAll(newusers);
      setState(() {
        tab4 = nodata();
        // tab4 = (users.length == 0) ? nodata() : userlist(users);
        hasresp4 = true;
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

    resp4header();
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
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
              title: Text('$arg的搜索结果'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => Navigator.pushNamed(context, '/search')),
              ],
              pinned: true,
              floating: true,
              bottom: TabBar(
                unselectedLabelColor: Colors.white.withOpacity(0.2),
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
            Refresh(
              enablePullUp: false,
              child: tab1,
              headercallback: () {
                hasresp1 = false;
                resp1header();
              },
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
            Refresh(
              child: tab4,
              headercallback: () {
                hasresp4 = false;
                resp4header();
              },
              footercallback: () {
                hasresp4 = false;
                resp4footer();
              },
            ),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
