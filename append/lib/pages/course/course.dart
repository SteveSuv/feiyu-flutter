import 'package:app/components/api.dart';
import 'package:flutter/material.dart';
import 'package:app/components/global.dart';
import 'package:flutter/widgets.dart';
import 'package:app/components/components.dart';

class Course extends StatefulWidget {
  Course({this.arg});
  final arg;
  State<StatefulWidget> createState() {
    return CourseState();
  }
}

class CourseState extends State<Course> with TickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  var tabs = [
    Tab(
      text: "列表",
    ),
    Tab(
      text: "收藏",
    ),
  ];

  var tab1 = pageload();
  var tab2 = pageload();

  var hasresp1 = false;
  var hasresp2 = false;

  var limit1 = 10;
  var index1 = 0;
  var skip1 = 0;

  var courses1 = [];
  var courses2 = [];

  void resp1header() async {
    if (hasresp1 == false) {
      limit1 = 10;
      index1 = 0;
      skip1 = 0;
      courses1 =
          await api_getdata('course', null, '-course_see', skip1, limit1);

      setState(() {
        tab1 =
            (courses1.length == 0) ? nodata() : courselist(courses1, context);
        hasresp1 = true;
      });
    }
  }

  void resp1footer() async {
    if (hasresp1 == false) {
      index1++;
      skip1 = index1 * limit1;
      List newcourses1 =
          await api_getdata('course', null, '-course_see', skip1, limit1);
      courses1.addAll(newcourses1);
      setState(() {
        tab1 =
            (courses1.length == 0) ? nodata() : courselist(courses1, context);
        hasresp1 = true;
      });
    }
  }

  void resp2header() async {
    if (hasresp2 == false) {
      var courses2_ids = await api_getdata('user', {'user_name': username},
          null, null, null, null, 'user_course');
      if (courses2_ids.length == 0) {
        setState(() {
          tab2 = nodata();
          hasresp2 = true;
        });
      } else {
        var res = courses2_ids[0]['user_course'];
        for (var i = 0; i < res.length; i++) {
          var res1 = await api_getdata('course', {'_id': res[i]});
          courses2.add(res1[0]);
        }
        setState(() {
          tab2 =
              (courses2.length == 0) ? nodata() : courselist(courses2, context);
          hasresp2 = true;
        });
      }
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
                title: Text('课程'),
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
              Refresh(
                enablePullUp: false,
                child: tab2,
                headercallback: () {
                  hasresp2 = false;
                  resp2header();
                },
              ),
            ],
            controller: _tabController,
          ),
        ),
        floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: () {
              Navigator.pushNamed(context, '/course_edit');
            },
            backgroundColor: themeColor,
            child: Icon(Icons.add)));
  }
}
