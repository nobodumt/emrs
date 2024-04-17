const express = require('express');
const controller = require('../controllers/mainController');
const router = express.Router();

// GET / (home)
router.get('/', controller.home);

// GET /about
router.get('/page2', controller.page2);

// GET /contact
router.get('/page1', controller.page1);

module.exports = router;