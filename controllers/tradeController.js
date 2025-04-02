const model = require('../models/trade');
const User = require('../models/user');

// GET /appts: send all appointments to the user (previously /trades)
exports.index = (req, res, next)=> {
    let id = req.session.user;
     /* Promise.all([model.find({creator: id}), User.findById({id})])
    .then(results =>{
        const [trades, user] = results;
        res.render('./appt/index', {trades});
    }) 
    .catch(err=>next(err)); */
    model.find()
    .then(trades=>res.render('./appt/index', {trades}))
    .catch(err=>next(err));
};

// GET /appts/newTrade: send html form for creating new appointment (and send user/physician's name) (previously /trades/newTrade)
exports.new = (req, res, next) => {
    //res.render('./appt/newTrade');
    let id = req.session.user;
    User.findById(id)
    .then(user=>{
            return res.render('./appt/newTrade', {user});
    })
    .catch(err=>next(err));
};

//POST /appts: create a new trade (previously /trades)
exports.create = (req, res, next) => {
    let trade = new model(req.body);
    trade.creator = req.session.user;
    trade.save()
    .then((trade)=>{
        req.flash('success', 'Appointment has been created successfully');
        res.redirect('/appts/'+trade.id);
        //res.redirect('/appts');
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

//GET /appts/:id: send details of trade identified by id (previously /trades/:id)
exports.show = (req, res, next) => {
    let id = req.params.id;
    model.findById(id).populate('creator', 'firstName lastName')
    .then(trade=>{
        if(trade) {
            return res.render('./appt/trade', {trade});
        } else {
            let err = new Error('Cannot find trade with id ' + id);
            err.status = 404;
            next(err);
        }
    })
    .catch(err=>next(err));
};

// GET /appts/:id/edit: send html form for editing an existing trade (previously /trades/:id/edit)
exports.edit = (req, res, next) => {
    let id = req.params.id;
    model.findById(id)
    .then(trade=>{
            return res.render('./appt/edit', {trade});
    })
    .catch(err=>next(err));
};

//PUT /appts/:id: update the trade identified by id (previously /trades/:id)
exports.update = (req, res, next) => {
    let trade = req.body;
    let id = req.params.id;

    model.findByIdAndUpdate(id, trade, {useFindAndModify: false, runValidators: true})
    .then(trade=>{
            res.redirect('/appts/'+id);
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

//DELETE /appts/:id, delete the trade identified by id  (previously /trades/:id)
exports.delete = (req, res, next) => {
    let id = req.params.id;

    model.findByIdAndDelete(id, {useFindAndModify: false})
    .then(trade=> {
            res.redirect('/users/profile');
    })
    .catch(err=>next(err));
};

//GET /trades/:id/trade: send info for user to initiate a trade for the item
/* exports.trading = (req, res, next) => {
    let id = req.params.id;
    res.send('initiate trade for shoe with id ' + id);
}; */