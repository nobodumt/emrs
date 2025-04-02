const express = require('express');
const controller = require('../controllers/tradeController');
const {isLoggedIn, isCreator, isAdmin} = require('../middlewares/auth');
const{validateId, validateTrade} = require('../middlewares/validator');
const router = express.Router();

// GET /appts: send all appointments to the user (previously /trades)
router.get('/', isLoggedIn, /*isAdmin,*/ controller.index);

// GET /appts/newTrade: send html form for creating new appointment (previously /trades/newTrade)
router.get('/newTrade', isLoggedIn, controller.new);

//POST /appts: create a new appointment (previously /trades)
router.post('/', isLoggedIn, validateTrade, controller.create);

//GET /appts/:id: send details of appointment identified by id (previously /trades/:id)
router.get('/:id', validateId, controller.show);

// GET /appts/:id/edit: send html form for editing an existing appointment (previously /trades/:id/edit)
router.get('/:id/edit', validateId, isLoggedIn, isCreator, controller.edit);

//PUT /appts/:id: update the appointment identified by id (previously /trades/:id)
router.put('/:id', validateId, isLoggedIn, isCreator, validateTrade, controller.update);

//DELETE /appts/:id, delete the appointment identified by id (previously /trades/:id)
router.delete('/:id', validateId, isLoggedIn, isCreator, controller.delete);

//GET /trades/:id/trade: send info for user to initiate a trade for the item
// router.get('/:id/trade', validateId, isLoggedIn, controller.trading);

module.exports = router;