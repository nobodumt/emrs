const model = require('../models/patient');

// GET / (home)
exports.home = (req, res) => {
    res.render('index');
};

// GET /about
exports.page2 = (req, res) => {
    res.render('page2');
};

// GET /contact
exports.page1 = (req, res) => {
    res.render('page1');
};

// GET /patients (list of all patients in EMRS)
exports.patients = (req, res) => {
    model.find()
    .then(patients=>res.render('./patient/index', {patients}))
    .catch(err=>next(err));
};

//GET /trades/:id: send details of patient identified by id
exports.showPatient = (req, res, next) => {
    let id = req.params.id;
    model.findById(id)
    .then(patient=>{
        if(patient) {
            return res.render('./patient/patient', {patient});
        } else {
            let err = new Error('Cannot find patient with id ' + id);
            err.status = 404;
            next(err);
        }
    })
    .catch(err=>next(err));
};