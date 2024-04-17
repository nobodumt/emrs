const {body} = require('express-validator');
const {validationResult} = require('express-validator');

exports.validateSignUp = [body('firstName', 'first name cannot be empty').notEmpty().trim().escape(),
body('lastName', 'Last name cannot be empty').notEmpty().trim().escape(),
body('email', 'Email must be a valid a valid email address').isEmail().trim().escape().normalizeEmail(), 
body('password', 'Password must be at least 8 characters and at most 64 characters').isLength({min: 8, max: 64})];

exports.validateLogin = exports.validateLogIn = [body('email', 'Email must be a valid a valid email address').isEmail().trim().escape().normalizeEmail(),
body('password', 'Password must be at least 8 characters and at most 64 characters').isLength({min: 8, max: 64})];

exports.validateTrade = [body('name', 'Trade name cannot be empty').notEmpty().trim().escape(),
body('status', 'Status cannot be empty').notEmpty().trim().escape().default("Upcoming"),
body('details', 'Details/description must be at least 10 characters').isLength({min: 10}).trim().escape(),
body('category', 'Category cannot be empty').notEmpty().trim()/*.escape()*/, //removed escape because it was not accepting the apostrophe character in the category names
body('size ', 'Size cannot be empty').notEmpty().trim().escape(),
body('color', 'Color cannot be empty').notEmpty().trim().escape(),
body('condition').trim().escape()];
//body('image', 'Image cannot be empty').notEmpty().trim().escape().default("https://upload.wikimedia.org/wikipedia/commons/3/3f/Placeholder_view_vector.svg")];

exports.validateId = (req, res, next)=> {
    let id = req.params.id;
    if(!id.match(/^[0-9a-fA-F]{24}$/)) {
        let err = new Error('Invalid trade id');
        err.status = 400;
        return next(err);
    } else {
        return next();
    }
};

exports.validateResult = (req, res, next) => {
    let errors = validationResult(req);
    if(!errors.isEmpty()){
        errors.array().forEach(error=>{
            req.flash('error', error.msg);
        });
        return res.redirect('back');
    } else {
        return next();
    }
};