const express = require('express');
const morgan = require("morgan");
const tradeRoutes = require('./routes/tradeRoutes');
const mainRoutes = require('./routes/mainRoutes');
const userRoutes = require('./routes/userRoutes');
const watchRoutes = require('./routes/watchRoutes');
//const patientRoutes = require('./routes/patientRoutes');
const methodOverride = require('method-override');
const mongoose = require('mongoose');
const mysql = require('mysql');
const session = require('express-session');
const mongoStore = require('connect-mongo');
const flash = require('connect-flash');

const app = express();

let port = 8000;
let host = 'localhost';
app.set('view engine', 'ejs');

mongoose.connect('mongodb://localhost:27017/emrs', {useNewUrlParser: true, useUnifiedTopology: true, useCreateIndex: true})
.then(()=>{
    app.listen(port, host, () => {
        console.log('Server is running on port', port);
    });
})
.catch(err=>console.log(err.message));

app.use(express.static('public'));
app.use(express.urlencoded({extended: true}));
app.use(morgan('tiny'));
app.use(methodOverride('_method'));

app.use(session({
    secret: 'secretstring',
    resave: false,
    saveUninitialized: false,
    // cookie: for 1 hour
    cookie: {maxAge: 60*60*1000},
    store: new mongoStore({mongoUrl: 'mongodb://localhost:27017/emrs'})
}));

app.use(flash());

// prints app session
app.use((req, res, next)=>{
    res.locals.user = req.session.user||null;
    res.locals.successMessages = req.flash('success');
    res.locals.errorMessages = req.flash('error');
    next();
});

//set up routes
app.use('/', mainRoutes);
app.use('/appts', tradeRoutes);
app.use('/users', userRoutes);
app.use('/watches', watchRoutes);
//app.use('/patients', patientRoutes);

app.use((req, res, next) => {
    let err = new Error('The server cannot locate ' + req.url);
    err.status = 404;
    next(err);
});

app.use((err, req, res, next)=>{
    if(!err.status) {
        err.status = 500;
        next(err);
        err.message = ("Internal Server Error");
    }

    res.status(err.status);
    res.render('error', {error: err});
});