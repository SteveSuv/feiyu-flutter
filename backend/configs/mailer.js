var mailer=function(toer,resetlink){

'use strict';

const nodemailer = require('nodemailer');

let transporter = nodemailer.createTransport({
  service: '163', 
  port: 465, 
  secureConnection: true, 
  auth: {
    user: '18920426097@163.com',
    pass: 'ztj250',
  }
});

let mailOptions = {
  from: '<18920426097@163.com>', 
  to:"<"+toer+">",
  subject: '修改密码链接',
  html: "亲爱的用户<br>点击此链接重置密码<br><a href="+resetlink+">"+resetlink+"</a>"
};


transporter.sendMail(mailOptions, (error, info) => {
  if (error) {
    console.log("邮件发送失败："+error);
  }else{
    console.log("邮件发送成功!");
  }
  
});

}

module.exports=mailer;