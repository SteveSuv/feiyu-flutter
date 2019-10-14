import 'package:app/components/api.dart';
import 'package:flutter/material.dart';
import 'package:app/components/global.dart';
import 'package:flutter/widgets.dart';
import 'package:app/components/components.dart';

class Home extends StatefulWidget {
  Home({this.arg});
  final arg;
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  var tabs = [
    Tab(
      text: "实时",
    ),
    Tab(
      text: "热门",
    ),

  ];

  var tab1 = pageload();
  var tab2 = pageload();

  var hasresp1 = false;
  var hasresp2 = false;


  var limit1 = 20;
  var index1 = 0;
  var skip1 = 0;

  var limit2 = 20;
  var index2 = 0;
  var skip2 = 0;


  var topics1 = [];
  var topics2 = [];


// --------------------最新-------------------------------------------

  void resp1header() async {
    if (hasresp1 == false) {
      limit1 = 20;
      index1 = 0;
      skip1 = 0;
      topics1 = await api_getdata('topic', null, '-sendtime', skip1, limit1);
      setState(() {
        tab1 = (topics1.length == 0)
            ? nodata()
            : cardlistview(context, topics1, '/topic_detail', topicitem);
        hasresp1 = true;
      });
    }
  }

  void resp1footer() async {
    if (hasresp1 == false) {
      index1++;
      skip1 = index1 * limit1;
      List newtopics1 =
          await api_getdata('topic', null, '-sendtime', skip1, limit1);
      topics1.addAll(newtopics1);
      setState(() {
        tab1 = (topics1.length == 0)
            ? nodata()
            : cardlistview(context, topics1, '/topic_detail', topicitem);
        hasresp1 = true;
      });
    }
  }

// --------------------最火-------------------------------------------

  void resp2header() async {
    if (hasresp2 == false) {
      limit2 = 20;
      index2 = 0;
      skip2 = 0;
      topics2 = await api_getdata('topic', null, '-topic_see', skip2, limit2);

      setState(() {
        tab2 = (topics2.length == 0)
            ? nodata()
            : cardlistview(context, topics2, '/topic_detail', topicitem);
        hasresp2 = true;
      });
    }
  }

  void resp2footer() async {
    if (hasresp2 == false) {
      index2++;
      skip2 = index2 * limit2;
      List newtopics2 =
          await api_getdata('topic', null, '-topic_see', skip2, limit2);
      topics2.addAll(newtopics2);
      setState(() {
        tab2 = (topics2.length == 0)
            ? nodata()
            : cardlistview(context, topics2, '/topic_detail', topicitem);
        hasresp2 = true;
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
                title: Text('首页'),
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
              
            ],
            controller: _tabController,
          ),
        ),
        floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: () {
              Navigator.pushNamed(context, '/topic_edit');
            },
            backgroundColor: themeColor,
            child: Icon(Icons.edit)));
  }
}
