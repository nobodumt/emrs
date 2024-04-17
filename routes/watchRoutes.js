const express = require('express');
const controller = require('../controllers/watchController');
const {isLoggedIn} = require('../middlewares/auth');
const{validateId} = require('../middlewares/validator');
const router = express.Router();

//POST /watches/:id: watch trade identified by id
router.post('/:id', validateId, isLoggedIn, /*validateWatch,*/ controller.watch);

module.exports = router;