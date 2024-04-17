const model = require('../models/user');
const Trade = require('../models/trade');
const Watch = require('../models/watch');

// GET /users/new: sign up page
exports.new = (req, res)=> {
    res.render('./user/new');
};

// POST /users: create new user
exports.create = (req, res, next)=> {
    if(!req.session.user) {
    let user = new model(req.body);
    if(user.email) {
        user.email = user.email.toLowerCase();
    }
    user.save()
    .then((user)=> {
        req.flash('success', 'You have successfully created an account');
        res.redirect('/users/login');
    })
    .catch(err=> {
        if(err.name === 'ValidationError') {
            req.flash('error', err.message);
            return res.redirect('/users/new');
        }
        
        if(err.code === 11000) {
            req.flash('error', 'Email address has already been used');
            return res.redirect('/users/new');
        }
        next(err);
    });
}
};

// GET /users/login: login page
exports.login = (req, res)=> {
    res.render('./user/login');
};

// POST /users/login: log in user
exports.loggedin = (req, res, next)=> {
    let email = req.body.email;
    if (email) {
        email = email.toLowerCase();
    }
    let password = req.body.password;

    model.findOne({email: email})
    .then(user=>{
        if(user){
            user.comparePassword(password)
            .then(result=>{
                if (result) {
                    req.session.user = user._id;
                    req.session.name = user.firstName;
                    req.flash('success', 'Welcome back, ' + req.session.name);
                    res.redirect('/users/profile');
                } else {
                    req.flash('error', 'Wrong password');
                    res.redirect('/users/login');
                }
            })
        } else {
            req.flash('error', 'Wrong email address');
            res.redirect('/users/login');
        }
    })
    .catch(err=>next(err));
};

// GET /users/profile: show user's profile/dashboard page
exports.profile = (req, res, next)=> {
    let id = req.session.user;
    Promise.all([model.findById(id), Trade.find({creator: id}), Watch.find({watcher: id})]) 
    .then(results =>{
        const [user, trades, watches] = results;
        res.render('./user/profile', {user, trades, watches});
    })
    .catch(err=>next(err));
};

// GET /users/logout: log out user
exports.logout = (req, res, next)=> {
    req.session.destroy(err=>{
        if(err){
            return next(err);
        } else {
            res.redirect('/');
        }
    });
};