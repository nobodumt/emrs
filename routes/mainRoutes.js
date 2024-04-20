const express = require('express');
const controller = require('../controllers/mainController');
const {isLoggedIn, isAdmin} = require('../middlewares/auth');
const router = express.Router();

// GET / (home)
router.get('/', controller.home);

// GET /about
router.get('/page2', controller.page2);

// GET /contact
router.get('/page1', controller.page1);

// GET /patients (all patients in EMRS)
router.get('/patients', isLoggedIn, controller.patients);

//GET /patients/:id: send details of patient identified by id
router.get('patients/:id', isLoggedIn, controller.showPatient);

module.exports = router;