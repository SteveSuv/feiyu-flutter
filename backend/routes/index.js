var express = require('express');
var apis = require('./api')
var uploader = require('../configs/uploader')
var router = express.Router();

router.all('/', (req, res) => {
    res.send('Hello,Api!')
})

router.all('/upload', uploader.single('file'), async (req, res) => {
    if (req.method.toUpperCase() !== 'PUT') {
        res.send('此接口的请求方式只能是PUT')

    }
    else {
        try {
            res.send(req.file)
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }
})

router.all('/uploads', uploader.array('files'), async (req, res) => {
    if (req.method.toUpperCase() !== 'PUT') {
        res.send('此接口的请求方式只能是PUT')

    }
    else {
        try {
            res.send(req.files)
        }
        catch (err) {
            res.send({ 'error': err.toString() })
        }
    }
})

router.all('*', (req, res) => {
    var Route = req.url.slice(req.url.indexOf('/') + 1, req.url.indexOf('?') < 0 ? Infinity : req.url.indexOf('?'))
    var Func = apis[Route]
    if (!!Func) {
        Func(req, res)
    }
    else {
        res.send('不存在此接口')
    }
})


module.exports = router

