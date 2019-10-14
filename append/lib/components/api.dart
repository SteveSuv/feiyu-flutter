import 'package:app/components/global.dart';
import 'package:dio/dio.dart';

// 表名
final tables = [
  'user',
  'topic',
  'course',
  'file',
  'comment',
  'payment',
  'msg',
  'feedback'
];

// -------------------------------------------------------------------------
// 是否登录
// {
//     user_name 必填
//     access_token 必填
// }
api_islogin(String user_name, String access_token) async {
  Response res = await service().post('/islogin',
      data: {"user_name": user_name, "access_token": access_token});
  return res.data;
}

// 注册
// {
//     "user_email" 必填
//     'user_name' 必填
//     "user_pwd" 必填
//     'user_avatar' 必填
//     'sendtime' 必填
// }
api_sign(
  String user_email,
  String user_name,
  String user_pwd,
  String user_avatar,
  int sendtime,
) async {
  Response res = await service().post('/sign', data: {
    "user_email": user_email,
    "user_name": user_name,
    "user_pwd": user_pwd,
    "user_avatar": user_avatar,
    "sendtime": sendtime
  });
  return res.data;
}

// 登录
// {
//     "user_email"/'user_id' 二选一
//     "user_pwd" 必填
//     'user_logindate' 必填
//     'user_ip' 必填
// }
api_login(String user_pwd, String user_logindate, String user_ip,
    [String user_id, String user_email]) async {
  Response res = await service().post('/login', data: {
    "user_email": user_email,
    "user_id": user_id,
    "user_pwd": user_pwd,
    "user_logindate": user_logindate,
    "user_ip": user_ip
  });
  return res.data;
}

// 退出登录
// {
//     user_name 必填
//     access_token 必填
// }
api_exit(String user_name, String access_token) async {
  Response res = await service().post('/exit',
      data: {"user_name": user_name, "access_token": access_token});
  return res.data;
}

// 重置密码

// --------------------------------------------------------------------------

// 查询
// {
//     table:表名,必填
//     condition:查找条件，
//     presort:限制前的排序，
//     skip:跳过的数量,
//     limit:返回的数量,
//     postsort:限制后的排序，
//     select:返回哪些值
// }
api_getdata(String table,
    [Map condition,
    String presort,
    int skip,
    int limit,
    String postsort,
    String select]) async {
  Response res = await service().get('/get', queryParameters: {
    "table": table,
    "condition": condition,
    'presort': presort,
    'skip': skip,
    'limit': limit,
    'postsort': postsort,
    'select': select
  });
  return res.data;
}

// 增加
// {
//     table:表名,必填,
//     condition:避免重复元素的条件,{},
//     data:内容
// }
api_adddata(String table, Map data, [Map condition]) async {
  Response res = await service().post('/add',
      data: {"table": table, "condition": condition, 'data': data});
  return res.data;
}

// 详情页
// {
//     table:表名,必填,
//     id,必填,
//     user_name,必填,
// }
api_getpage(String table, String id, String user_name) async {
  Response res = await service().get('/detail',
      queryParameters: {"table": table, "id": id, 'user_name': user_name});
  return res.data;
}

// 隐藏/恢复
// {
//     table:表名,必填,
//     id,必填,
// }
api_ishide(String table, String id) async {
  Response res =
      await service().post('/hide', data: {"table": table, "id": id});
  return res.data;
}

// 点赞/取消点赞
// {
//     table:表名,必填,
//     user_name,必填,
//     id,必填,
// }
api_thumb(String table, String id, String user_name) async {
  Response res = await service().get('/thumb',
      queryParameters: {"table": table, "id": id, 'user_name': user_name});
  return res.data;
}

// 下载文件
// {
//     id,文件id,必填,
//     user_name:必填
// }
api_download(String id, String user_name) async {
  Response res = await service()
      .get('/download', queryParameters: {"id": id, 'user_name': user_name});
  return res.data;
}
