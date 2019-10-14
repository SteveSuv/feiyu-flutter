// 模块
var mongoose = require('mongoose');

// 设置
var DB_URL = 'mongodb://localhost:27017/feiyu';
var default_avatar = 'https://i.loli.net/2019/10/08/hZulBDEdU2pIsqN.png'

// 连接
mongoose.connect(DB_URL, { useNewUrlParser: true }, function (err) {
    if (err) {
        console.log('数据库连接失败:' + err)
    } else {
        console.log('数据库连接成功!')
    }
});

// -------------------------------------------------------
// 数据构造

// 用户
var User = new mongoose.Schema({
    user_name: { type: String },
    user_id: { type: Number },
    user_email: { type: String },
    user_pwd: { type: String },
    user_birth: { type: String },
    user_sex: { type: String },
    user_qq: { type: String },
    user_wx: { type: String },
    user_zone_see: { type: Number, default: 0 },
    user_ip: { type: Array, default: [] },
    user_location: { type: String },
    user_avatar: { type: String, default: default_avatar },
    user_logindate: { type: String },//最新登录时间
    user_msgs: { type: Array, default: [] },
    user_download: { type: Array, default: [] },
    user_course: { type: Array, default: [] },
    user_history: { type: Array, default: [] },
    user_thumb_up: { type: Array, default: [] },
    user_comments: { type: Array, default: [] },
    user_groupjoin: { type: Array, default: [] },
    access_token: { type: String },
    hide: { type: Boolean, default: false },
    user_state: {
        type: Object, default: {
            // 0正常 1禁言 2封号 3会员 ...
            state: { type: Number, default: 1 },
            endtime: { type: Number, default: Infinity },
        }
    },
    sendtime: { type: Number },//注册时间
}, {
    collection: "user"//指定对应哪个集合，不然会自动加s
})

//动态
var Topic = new mongoose.Schema({
    topic_author: {
        type: Object, default: {

            name: { type: String },
            avatar: { type: String },
            ip: { type: String },
        }
    },
    topic_title: { type: String },
    topic_label: { type: String },
    topic_content: { type: String },
    topic_images: { type: Array, default: [] },
    topic_see: { type: Number, default: 0 },
    topic_up: { type: Number, default: 0 },
    topic_comment: { type: Array, default: [] },
    topic_showtime: { type: String },
    sendtime: { type: Number },

    hide: { type: Boolean, default: false }
}, {
    collection: "topic"//指定对应哪个集合，不然会自动加s+
})

// 问答
var Question = new mongoose.Schema({
    question_author: {
        type: Object, default: {

            name: { type: String },
            avatar: { type: String },
            ip: { type: String },

        }
    },
    question_answer: { type: Array, default: [] },
    question_title: { type: String },
    question_label: { type: String },
    question_content: { type: String },
    question_images: { type: Array, default: [] },
    question_see: { type: Number, default: 0 },
    question_up: { type: Number, default: 0 },
    question_showtime: { type: String },
    sendtime: { type: Number },

    hide: { type: Boolean, default: false }
}, {
    collection: "question"//指定对应哪个集合，不然会自动加s+
})


var Answer = new mongoose.Schema({
    answer_author: {
        type: Object, default: {
            name: { type: String },
            avatar: { type: String },
            ip: { type: String },
        }
    },
    answer_question: { type: String },//question id
    answer_title: { type: String },//question title
    answer_content: { type: String },
    answer_images: { type: Array, default: [] },
    answer_see: { type: Number, default: 0 },
    answer_up: { type: Number, default: 0 },
    answer_comment: { type: Array, default: [] },
    answer_showtime: { type: String },
    sendtime: { type: Number },

    hide: { type: Boolean, default: false }
}, {
    collection: "answer"//指定对应哪个集合，不然会自动加s+
})


// 组队
var Group = new mongoose.Schema({
    group_author: {
        type: Object, default: {

            name: { type: String },
            avatar: { type: String },
            ip: { type: String },
        }
    },
    group_title: { type: String },
    group_label: { type: String },
    group_images: { type: Array, default: [] },
    group_content: { type: String },
    group_need: { type: Number, default: 0 },
    group_have: { type: Number, default: 0 },
    group_see: { type: Number, default: 0 },
    group_comment: { type: Object, default: [] },
    group_person: { type: Object, default: [] },
    group_showtime: { type: String },
    sendtime: { type: Number },

    hide: { type: Boolean, default: false }
}, {
    collection: "group"//指定对应哪个集合，不然会自动加s+
})



// 课程
var Course = new mongoose.Schema({
    course_author: {
        type: Object, default: {

            name: { type: String },
            avatar: { type: String },
            ip: { type: String },
        }
    },
    course_title: { type: String },
    course_content: { type: String },
    course_see: { type: Number, default: 0 },
    course_mark: { type: Number, default: 10 },
    course_showtime: { type: String },
    course_comment: { type: Array, default: [] },
    sendtime: { type: Number },

    hide: { type: Boolean, default: false }
}, {
    collection: "course"//指定对应哪个集合，不然会自动加s+
})

// 资料
var File = new mongoose.Schema({
    file_author: {
        type: Object, default: {

            name: { type: String },
            avatar: { type: String },
            ip: { type: String },
        }
    },
    file_title: { type: String },
    file_size: { type: String },
    file_label: { type: String },
    file_up: { type: Number, default: 0 },
    file_path: { type: String },
    file_comment: { type: Array, default: [] },
    file_mark: { type: Number, default: 10 },
    file_see: { type: Number, default: 0 },
    file_download: { type: Number, default: 0 },
    file_showtime: { type: String },
    sendtime: { type: Number },

    hide: { type: Boolean, default: false }
}, {
    collection: "file"//指定对应哪个集合，不然会自动加s+
})

// 评论
var Comment = new mongoose.Schema({
    comment_author: {
        type: Object, default: {

            name: { type: String },
            avatar: { type: String },
            ip: { type: String },

        }
    },
    comment_to: { type: String },
    comment_pid: { type: String },//id
    comment_label: { type: String },//表
    comment_content: { type: String },
    comment_images: { type: Array, default: [] },
    comment_see: { type: Number, default: 0 },
    comment_up: { type: Number, default: 0 },
    comment_showtime: { type: String },
    sendtime: { type: Number },

    hide: { type: Boolean, default: false }
}, {
    collection: "comment"//指定对应哪个集合，不然会自动加s+
})

// 订单
var Payment = new mongoose.Schema({
    payment_author: {
        type: Object, default: {

            name: { type: String },
            avatar: { type: String },
            ip: { type: String },

        }
    },
    payment_title: { type: String },
    payment_content: { type: String },
    payment_showtime: { type: String },
    sendtime: { type: Number },

    hide: { type: Boolean, default: false }
}, {
    collection: "payment"//指定对应哪个集合，不然会自动加s+
})

// 私信
var Msg = new mongoose.Schema({
    msg_from: {
        type: Object, default: {

            name: { type: String },
            avatar: { type: String },
            ip: { type: String },

        }
    },
    msg_to: {
        type: Object, default: {

            name: { type: String },
            avatar: { type: String },
            ip: { type: String },

        }
    },
    msg_route: { type: String },
    msg_text: { type: String },
    msg_show: { type: Boolean, default: false },
    msg_showtime: { type: String },
    sendtime: { type: Number },
    hide: { type: Boolean, default: false }
}, {
    collection: "msg"//指定对应哪个集合，不然会自动加s+
})


// 反馈
var Feedback = new mongoose.Schema({
    feedback_author: {
        type: Object, default: {

            name: { type: String },
            avatar: { type: String },
            ip: { type: String },

        }
    },
    feedback_title: { type: String },
    feedback_content: { type: String },
    feedback_images: { type: Array, default: [] },
    feedback_showtime: { type: String },
    sendtime: { type: Number },

    hide: { type: Boolean, default: false }
}, {
    collection: "feedback"//指定对应哪个集合，不然会自动加s+
})

// --------------------接口----------------------------------

var tables = ['user', 'topic', 'course', 'file', 'comment', 'payment', 'msg', 'feedback']
var models={}
for(let i=0;i<tables.length;i++){
    let table=tables[i]
    let schema=eval(table.replace(table[0],table[0].toUpperCase()))
    models[table]=new mongoose.model(table,schema)
}

module.exports=models;



