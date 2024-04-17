const model = require('../models/watch');
const Trade = require('../models/trade');

//POST /watches/:id: watch trade identified by id
exports.watch = (req, res, next) => {
    //let trade = req.body;
    let id = req.params.id;
    Trade.findById(id)
    .then(trade=>{
        let watch = new model({
            watcher: req.session.user,
            tradeId: id,
            name: trade.name,
            category: trade.category,
            status: trade.status
        });
        watch.save();
        req.flash('success', 'Trade is under your watch');   
        res.redirect('/users/profile');
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