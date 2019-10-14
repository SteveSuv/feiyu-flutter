var models = require('../configs/dbconnect');
var mailer = require('../configs/mailer');
var jwt = require('jsonwebtoken')
const secret = 'ztj250'
var CryptoJS = require("crypto-js");




// ------------函数部分（main）-----------------------

function counts(model) {
    return model.find().countDocuments()
}


// -------------账号-----------------


// -----------------------是否登录---------------toUpperCase!==-----------
// {methods:post
//     user_name 必填
//     access_token 必填
// }
async function Islogin(req, res) {
    if (req.method.toUpperCase() !== 'POST') {
        res.send('请求方式错误')
    }
    else {
        try {
            var qe = req.body
            var resp = await models.user.find(qe).countDocuments()
            resp > 0 ? res.send('1') : res.send('2')
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }

};

// -----------------------用户登录--------------------------
// {methods:post
//     "user_email" 必填
//     "user_pwd" 必填
//     'user_logindate' 必填
//     'user_ip' 必填
// }
async function Login(req, res) {
    if (req.method.toUpperCase() !== 'POST') {
        res.send('请求方式错误')
    }
    else {
        try {
            var qe = req.body
            var jwtpwd = jwt.sign(qe.user_pwd, secret)
            var logininfo = qe.user_email ?
                { 'user_email': qe.user_email, 'user_pwd': jwtpwd } :
                { 'user_id': qe.user_id, 'user_pwd': jwtpwd }
            var res2 = await models.user.find(logininfo).countDocuments()
            if (res2 > 0) {
                var res3 = await models.user.findOne(logininfo)
                var token = jwt.sign(res3.user_name, secret)
                res3.access_token = token
                res3.user_logindate = qe.user_logindate
                res3.user_ip.push(qe.user_ip)
                await res3.save()
                var data = {
                    'user_name': res3.user_name,
                    'access_token': res3.access_token,
                    'user_avatar': res3.user_avatar,
                    'user_id': res3.user_id
                }
                res.send(data);//成功登录
            }
            else {
                res.send('2')//没有该用户
            }
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }
}

// -----------------------用户登出--------------------------
// {methods:post
//     "user_name" 必填
// }
async function Exit(req, res) {
    if (req.method.toUpperCase() !== 'POST') {
        res.send('请求方式错误')
    }
    else {
        try {
            var qe = req.body
            await models.user.updateOne(qe, { access_token: undefined })
            res.send('1')//成功退出
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }
}

// --------------------------用户注册----------------------
// {methods:post
//     "user_email" 必填
//     'user_name' 必填
//     "user_pwd" 必填
//     'user_avatar' 必填
//     'sendtime' 必填
// }
async function Sign(req, res) {
    if (req.method.toUpperCase() !== 'POST') {
        res.send('请求方式错误')
    }
    else {
        try {
            var qe = req.body
            var res2 = await models.user.find({ 'user_email': qe.user_email }).countDocuments()
            if (res2 > 0) {
                res.send('2')//email重复
            }
            else {
                var res3 = await models.user.find({ 'user_name': qe.user_name }).countDocuments()
                if (res3 > 0) {
                    res.send('3')//name重复
                }
                else {
                    var count = await counts(models.user);
                    qe.user_id = 741852 + count + 1
                    qe.user_pwd = jwt.sign(qe.user_pwd, secret)
                    var onedata = new models.user(qe);
                    await onedata.save()
                    res.send('1')//注册成功
                }
            }
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }
}

//------------------------------忘记密码----------------------
// {
//     method:post,
//     user_email:必填
// }
async function Reset(req, res) {
    if (req.method.toUpperCase() !== 'POST') {
        res.send('请求方式错误')
    }
    else {
        try {
            var qe = req.body
            var res2 = await models.user.find({ 'user_email': qe.user_email }).countDocuments()
            if (res2 > 0) {
                res.send('1')//修改密码邮件已经发送
                // 加密
                var email = CryptoJS.AES.encrypt(qe.user_email, 'ztj2507698457');
                var link = 'http://account.tju.wiki/userresetpwd?ue=' + email
                // console.log(link)
                mailer(qe.user_email, link);
            }
            else {
                res.send('2')//该邮箱未注册
            }
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }
}

//---------------------------更改密码(分为已登录的更改和未登录的更改)------------
// {
//     method:post,
//     user_name,
//     data
// }
async function Changeinfo(req, res) {
    if (req.method.toUpperCase() !== 'POST') {
        res.send('请求方式错误')
    }
    else {
        try {
            var qe = req.body
            var wherestr = { 'user_name': qe.user_name }
            var res2 = await models.user.findOne(wherestr)
            for (let i in qe.data) {
                if (i === 'user_pwd') {
                    res2[i] = jwt.sign(qe.data[i], secret)
                } else {
                    res2[i] = qe.data[i]
                }
            }
            await res2.save()
            res.send('1')
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }
}







// ---------------------------基本-------------------------------------




// {method:get
//     table:表名,必填
//     condition:查找条件，
//     presort:限制前的排序，
//     skip:跳过的数量,
//     limit:返回的数量,
//     postsort:限制后的排序，
//     select:返回哪些值
// }
async function Get(req, res) {
    if (req.method.toUpperCase() !== 'GET') {
        res.send('请求方式错误')
    }
    else {
        try {
            var qe = req.query
            var model = models[qe.table]
            var count = await counts(model)

            qe.condition = qe.condition ? qe.condition : {}
            qe.presort = qe.presort ? qe.presort : ''
            qe.skip = qe.skip ? qe.skip : 0
            qe.limit = qe.limit ? qe.limit : count
            qe.postsort = qe.postsort ? qe.postsort : ''
            qe.select = qe.select ? qe.select : ''
            var findcondition = (typeof (qe.condition) === String) ? JSON.parse(qe.condition) : qe.condition
            findcondition['hide'] = false
            var resp = await model
                .find(findcondition)
                .sort(qe.presort)
                .skip(~~(qe.skip))
                .limit(~~(qe.limit))
                .sort(qe.postsort)
                .select(qe.select);
            res.send(resp)//success
        }

        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }

};


// -----------------------------------增加-------------------
// {method:post
//     table:表名,必填,
//     condition:避免重复元素的条件,{},
//     data:内容
// }
async function Add(req, res) {
    if (req.method.toUpperCase() !== 'POST') {
        res.send('请求方式错误')
    }
    else {
        try {
            var qe = req.body
            var model = models[qe.table]
            var onedata = new model(qe.data);
            var res2 = qe.condition ? await model.find(qe.condition).countDocuments() : 0
            if (res2 == 0) {
                await onedata.save()
                res.send('1')//success
            } else {
                res.send('2')//重复
            }
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }
};

// -----------------------------------详情页----------------------
// {method:get
//     table:表名,必填,
//     id,必填,
//     user_name,必填,
// }
async function Detail(req, res) {
    if (req.method.toUpperCase() !== 'GET') {
        res.send('请求方式错误')
    }
    else {
        try {
            var qe = req.query
            var model = models[qe.table]
            var see = qe.table + '_see'
            var wherestr = { '_id': qe.id }
            var res2 = await model.findOne(wherestr)
            res2[see]++
            await res2.save()
            var res4 = await models.user.findOne({ 'user_name': qe.user_name })
            res4.user_history.push(qe.id)
            res4.user_history = Array.from(new Set(res4.user_history))
            await res4.save()
            res.send(res2)//success
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }
}

// --------------------删除/恢复（数据库没有删除，只是把hide改为true）----------------
// {method:post
//     table:表名,必填,
//     id,必填,
// }
async function Hide(req, res) {
    if (req.method.toUpperCase() !== 'POST') {
        res.send('请求方式错误')
    }
    else {
        try {
            var qe = req.body
            var model = models[qe.table]
            var wherestr = { '_id': qe.id }
            var res2 = await model.findOne(wherestr)
            await model.updateOne(wherestr, { hide: !res2.hide })
            res.send('1')
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }
}



// ---------------------点赞/取消点赞---------------------------------
// {method:get
//     table:表名,必填,
//     user_name,必填,
//     id,必填,
// }
async function Thumb(req, res) {
    if (req.method.toUpperCase() !== 'GET') {
        res.send('请求方式错误')
    }
    else {
        try {
            var qe = req.query
            var model = models[qe.table]
            var up = qe.table + '_up'
            var wherestr = { '_id': qe.id }
            var res2 = await model.findOne(wherestr)
            var res3 = await models.user.findOne({ 'user_name': qe.user_name })

            if (res3.user_thumb_up.indexOf(qe.id) < 0) {
                res2[up]++
                await res2.save()

                res3.user_thumb_up.push(qe.id)
                res3.user_thumb_up = Array.from(new Set(res3.user_thumb_up))
                await res3.save()

                res.send('1')//点赞成功

            }
            else {
                res2[up]--
                await res2.save()

                var index = res3.user_thumb_up.indexOf(qe.id)
                res3.user_thumb_up.splice(index, 1)
                await res3.save()

                res.send('2')//取消点赞成功


            }
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }
}

// ----------------文件下载---------------------------------------------
// {method:get
//     id,必填,
//     user_name:必填
// }
async function Download(req, res) {
    if (req.method.toUpperCase() !== 'GET') {
        res.send('请求方式错误')
    }
    else {
        try {
            var qe = req.query
            var res2 = await models.file.find({ _id: qe.id })
            res2.file_download++
            await res2.save()
            var res4 = await models.user.findOne({ 'user_name': qe.user_name })
            res4.user_download.push(qe.id)
            res4.user_download = Array.from(new Set(res4.user_download))
            await res4.save()
            res.send('1')//success
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }
}


// ------------导出部分-----------------------

var apinames = [
    'get',
    'add',
    'detail',
    'hide',
    'thumb',
    'download',
    // --------
    'islogin',
    'login',
    'sign',
    'exit',
    'reset',
    'changeinfo'
]

var apis = {}
for (let i = 0; i < apinames.length; i++) {
    var api = apinames[i]
    apis[api] = eval(api.replace(api[0], api[0].toUpperCase()))
}


module.exports = apis