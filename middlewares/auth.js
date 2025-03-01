const Trade = require('../models/trade');
var ObjectId = require('bson').ObjectId;
var adminId = new ObjectId('6455b94454180c4f048fae5d');

exports.isGuest = (req, res, next)=> {
    if(!req.session.user) {
        return next();
    } else {
        req.flash('error', 'You are logged in already');
        return res.redirect('/users/profile');
    }
};

exports.isLoggedIn = (req, res, next)=> {
    if(req.session.user) {
        return next();
    } else {
        req.flash('error', 'You need to login first');
        return res.redirect('/users/login');
    }
};

exports.isCreator = (req, res, next) =>{
    let id = req.params.id;
    Trade.findById(id)
    .then(trade=>{
        if(trade) {
            if(trade.creator == req.session.user) {
                return next();
            } else {
                let err = new Error('Unauthorized access for this resource');
                err.status = 401;
                return next(err);
            }
        } else {
            let err = new Error('Cannot find a trade with id ' + req.params.id);
            err.status = 404;
            return next(err);
        }
    })
    .catch(err=>next(err));
};
// ensures the user account is an administrative account like the receptionist's account for instance
exports.isAdmin = (req, res, next)=> {
    if(req.session.user/* == adminId*/) {
        //print(req.session.user)
        return next();
    } else {
        req.flash('error', 'You are not authorized for access');
        return res.redirect('back');
    }
};