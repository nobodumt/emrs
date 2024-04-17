const model = require('../models/user');

// GET / (home)
exports.home = (req, res, next) => {
    let id = req.session.user;
    Promise.all([model.findById(id)]) 
    .then(results =>{
        const [user] = results;
        res.render('index', {user});
    })
    .catch(err=>next(err));
    //res.render('index');
};

// GET /about
exports.page2 = (req, res, next) => {
    let id = req.session.user;
    Promise.all([model.findById(id)]) 
    .then(results =>{
        const [user] = results;
        res.render('page2', {user});
    })
    .catch(err=>next(err));
    //res.render('page2');
};

// GET /contact
exports.page1 = (req, res, next) => {
    let id = req.session.user;
    Promise.all([model.findById(id)]) 
    .then(results =>{
        const [user] = results;
        res.render('page1', {user});
    })
    .catch(err=>next(err));
    //res.render('page1');
};