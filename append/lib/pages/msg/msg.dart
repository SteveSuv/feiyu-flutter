import 'package:flutter/material.dart';
import 'package:app/components/global.dart';
import 'package:flutter/widgets.dart';
import 'package:app/components/components.dart';
import 'package:app/components/api.dart';

class Msg extends StatefulWidget {
  Msg({this.arg});
  final arg;
  State<StatefulWidget> createState() {
    return MsgState();
  }
}

class MsgState extends State<Msg> with TickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  var tabs = [
    Tab(
      text: "提到我",
    ),
    Tab(
      text: "回复我",
    ),
    Tab(
      text: "点赞我",
    ),
    Tab(
      text: "私信我",
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

  var msgs1 = [];
  var msgs2 = [];
  var msgs3 = [];
  var msgs4 = [];

  void resp1header() async {
    if (hasresp1 == false) {
      limit1 = 20;
      index1 = 0;
      skip1 = 0;
      msgs1 = await api_getdata('msg', null, '-sendtime', skip1, limit1);
      setState(() {
        tab1 = (msgs1.length == 0) ? nodata() : msglist(msgs1,context);
        hasresp1 = true;
      });
    }
  }

  void resp1footer() async {
    if (hasresp1 == false) {
      index1++;
      skip1 = index1 * limit1;
      List newmsgs = await api_getdata('msg', null, '-sendtime', skip1, limit1);
      msgs1.addAll(newmsgs);
      setState(() {
        tab1 = (msgs1.length == 0) ? nodata() : msglist(msgs1,context);
        hasresp1 = true;
      });
    }
  }

  void resp2header() async {
    if (hasresp2 == false) {
      limit2 = 20;
      index2 = 0;
      skip2 = 0;
      var msgs2 = await api_getdata('msg', null, '-sendtime', skip2, limit2);
      setState(() {
        tab2 = (msgs2.length == 0) ? nodata() : msglist(msgs2,context);
        hasresp2 = true;
      });
    }
  }

  void resp2footer() async {
    if (hasresp2 == false) {
      index2++;
      skip2 = index2 * limit2;
      List newmsgs = await api_getdata('msg', null, '-sendtime', skip2, limit2);
      msgs2.addAll(newmsgs);
      setState(() {
        tab2 = (msgs2.length == 0) ? nodata() : msglist(msgs2,context);
        hasresp2 = true;
      });
    }
  }

  void resp3header() async {
    if (hasresp3 == false) {
      limit3 = 20;
      index3 = 0;
      skip3 = 0;
      var msgs3 = await api_getdata('msg', null, '-sendtime', skip3, limit3);
      setState(() {
        tab3 = (msgs3.length == 0) ? nodata() : msglist(msgs3,context);
        hasresp3 = true;
      });
    }
  }

  void resp3footer() async {
    if (hasresp3 == false) {
      index3++;
      skip3 = index3 * limit3;
      List newmsgs = await api_getdata('msg', null, '-sendtime', skip3, limit3);
      msgs3.addAll(newmsgs);
      setState(() {
        tab3 = (msgs3.length == 0) ? nodata() : msglist(msgs3,context);
        hasresp3 = true;
      });
    }
  }

  void resp4header() async {
    if (hasresp4 == false) {
      limit4 = 20;
      index4 = 0;
      skip4 = 0;
      var msgs4 = await api_getdata('msg', null, '-sendtime', skip4, limit4);
      setState(() {
        tab4 = (msgs4.length == 0) ? nodata() : msglist(msgs4,context);
        hasresp4 = true;
      });
    }
  }

  void resp4footer() async {
    if (hasresp4 == false) {
      index4++;
      skip4 = index4 * limit4;
      List newmsgs = await api_getdata('msg', null, '-sendtime', skip4, limit4);
      msgs4.addAll(newmsgs);
      setState(() {
        tab4 = (msgs4.length == 0) ? nodata() : msglist(msgs4,context);
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
              title: Text('消息'),
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
