// patientRoutes is not currently being used, but created the file in case I want to move routes for patient pages here later.
const express = require('express');
const controller = require('../controllers/mainController');
const {isLoggedIn} = require('../middlewares/auth');
const router = express.Router();

// GET /patients (all patients in EMRS)
router.get('/', isLoggedIn, controller.patients);

module.exports = router;