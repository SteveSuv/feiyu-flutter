
// var obj = {
//     method: ['GET', 'POST'],
//     api: apis,//引入apis
//     query: json,//api会提示
//     data: json,//api会提示
//     upload: (e) => {},//调用进度条组件
//     download: (e) => {},//调用进度条组件
// }

function Http(obj) {
    axios({
        baseURL: '...',
        method: obj.method.toUpperCase(),
        url: obj.api,
        query: obj.query,
        data: obj.data,
        onUploadProgress: obj.upload,
        onDownloadProgress: obj.download,
    })
}

```
前端通过调用Http(obj)来发起请求，后端通过url接口找到对应处理函数，
通过query或者data来处理请求，最终返回相应的处理结果
为了保证稳定性，前端需要拿到后端根据函数生成的apis
而前端使用api,query,data赋值时api会给予相应提示

类 面向对象 通用接口 数据库的构造

```




