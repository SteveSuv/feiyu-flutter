var express = require('express');
var bodyParser = require('body-parser');
var app = express();

app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');
app.use(express.static('public'))
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());



var Router = require('./routes/index');
app.use('/api', Router);

app.listen('4000', () => {
    console.log('local: http://127.0.0.1:4000');
});
