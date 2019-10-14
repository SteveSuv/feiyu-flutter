import 'package:app/components/api.dart';
import 'package:app/components/global.dart';
import 'package:app/components/components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FileEdit extends StatefulWidget {
  final arg;
  FileEdit({Key key, this.arg}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return FileEditState(arg: arg);
  }
}

class FileEditState extends State<FileEdit> {
  FileEditState({this.arg});
  var arg;

  @override
  void initState() {
    super.initState();
    setip() async {
      var ip = await getip();
      print(ip);
      setState(() {
        author_ip = ip;
      });
    }

    setip();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List files = [];
  String author_ip = '';
  List file_paths = [];
  String picktext = '选择文件';

  resp() async {
    if (files.length != 0) {
      loading(context);
      FormData formData = FormData.from({"files": tofiles(files)});
      Response res2 = await service().put(
        "/uploads",
        data: formData,
        onSendProgress: (sent, total) {
          toast('已完成'+toprecent(sent/total), context);
        },
      );
      var resarr = res2.data;
      for (var i = 0; i < resarr.length; i++) {
        print(resarr[i]);
        // file_paths.add('$serverip/upload/${resarr[i]['filename']}');
        var file_path = '$serverip/upload/${resarr[i]['filename']}';
        var fsize = resarr[i]['size'] / 1024 / 1024;
        var file_size = '${fsize.toStringAsFixed(1)}M';
        var file_title = '${resarr[i]['originalname']}';
        await api_adddata(
          'file',
          {
            'file_author': {
              'name': username,
              'avatar': useravatar,
              'ip': author_ip,
            },
            'file_label': '$arg',
            'file_size': file_size.toString(),
            'file_path': file_path.toString(),
            'file_title': file_title.toString(),
            'file_showtime': time()['showtime'],
            'sendtime': time()['sendtime'],
          },
        );
      }
      Navigator.pop(context);

      Navigator.pop(context);
      toast('上传成功', context);
    } else {
      toast('请先选择文件', context);
    }
  }

  void forSubmitted() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();

      resp();
    }
  }

  filelist(List arr) {
    var filelists = [];
    for (var i = 0; i < arr.length; i++) {
      filelists.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: ButtonTheme(
            height: 50,
            shape: circle(5.0),
            buttonColor: themeColor.withOpacity(0.1),
            child: RaisedButton(
              highlightElevation: 0,
              elevation: 0,
              onPressed: () {
                alert(context, '提示', '确认移除此文件吗', () {
                  setState(() {
                    files.removeAt(i);
                  });
                  Navigator.pop(context);
                });
              },
              child: Text(
                "${tofilename(arr[i])}",
                style: TextStyle(color: themeColor),
              ),
            ),
          )));
    }
    return filelists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeColor,
        title: Text('上传资料'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                labelfield(arg),
                ListTile(
                    leading: Icon(
                      Icons.insert_drive_file,
                      color: themeColor,
                    ),
                    title: Text('$picktext'),
                    onTap: () {
                      pickfile((List e) {
                        setState(() {
                          files.addAll(e);
                          picktext = '已选择${files.length}个文件';
                        });
                        print(files);
                      });
                    }),
            
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ...filelist(files),
          SizedBox(
            height: 50,
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical:20, horizontal: 15),
              child: ButtonTheme(
                height: 50,
                shape: circle(5.0),
                buttonColor: themeColor,
                child: RaisedButton(
                  highlightElevation: 0,
                  elevation: 0,
                  onPressed: () {
                    forSubmitted();
                  },
                  child: Text(
                    "上传",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
