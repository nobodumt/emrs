const model = require('../models/trade');
const User = require('../models/user');

// GET /trades: send all appointments to the user
exports.index = (req, res, next)=> {
    let id = req.session.user;
    Promise.all([model.find(), User.findById({id})])
    .then(results =>{
        const [trades, user] = results;
        res.render('./trade/index', {trades});
    })
    .catch(err=>next(err)); 
    /*model.find()
    .then(trades=>res.render('./trade/index', {trades}))
    .catch(err=>next(err));*/
};

// GET /trades/newTrade: send html form for creating new appointment (and send user/physician's name)
exports.new = (req, res, next) => {
    //res.render('./trade/newTrade');
    let id = req.session.user;
    User.findById(id)
    .then(user=>{
            return res.render('./trade/newTrade', {user});
    })
    .catch(err=>next(err));
};

//POST /trades: create a new trade
exports.create = (req, res, next) => {
    let trade = new model(req.body);
    trade.creator = req.session.user;
    trade.save()
    .then((trade)=>{
        req.flash('success', 'Appointment has been created successfully');
        res.redirect('/trades/'+trade.id);
        //res.redirect('/trades');
    })
    .catch(err=>{
        if(err.name === 'ValidationError') {
            err.status = 400;
            req.flash('error', err.message);
            res.redirect('back'); 
        }
        next(err);
    });
    
};

//GET /trades/:id: send details of trade identified by id
exports.show = (req, res, next) => {
    let id = req.params.id;
    model.findById(id).populate('creator', 'firstName lastName')
    .then(trade=>{
        if(trade) {
            return res.render('./trade/trade', {trade});
        } else {
            let err = new Error('Cannot find trade with id ' + id);
            err.status = 404;
            next(err);
        }
    })
    .catch(err=>next(err));
};

// GET /trades/:id/edit: send html form for editing an existing trade
exports.edit = (req, res, next) => {
    let id = req.params.id;
    model.findById(id)
    .then(trade=>{
            return res.render('./trade/edit', {trade});
    })
    .catch(err=>next(err));
};

//PUT /trades/:id: update the trade identified by id
exports.update = (req, res, next) => {
    let trade = req.body;
    let id = req.params.id;

    model.findByIdAndUpdate(id, trade, {useFindAndModify: false, runValidators: true})
    .then(trade=>{
            res.redirect('/trades/'+id);
    })
    .catch(err=> {
        if(err.name === 'ValidationError') {
            err.status = 400;
            req.flash('error', err.message);
            res.redirect('back');
        }
        next(err)
    });
};

//DELETE /trades/:id, delete the trade identified by id
exports.delete = (req, res, next) => {
    let id = req.params.id;

    model.findByIdAndDelete(id, {useFindAndModify: false})
    .then(trade=> {
            res.redirect('/users/profile');
    })
    .catch(err=>next(err));
};

//GET /trades/:id/trade: send info for user to initiate a trade for the item
exports.trading = (req, res, next) => {
    let id = req.params.id;
    res.send('initiate trade for shoe with id ' + id);
};