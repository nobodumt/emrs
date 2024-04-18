const express = require('express');
const controller = require('../controllers/tradeController');
const {isLoggedIn, isCreator, isAdmin} = require('../middlewares/auth');
const{validateId, validateTrade} = require('../middlewares/validator');
const router = express.Router();

// GET /trades: send all appointments to the user
router.get('/', isLoggedIn, isAdmin, controller.index);

// GET /trades/newTrade: send html form for creating new trade
router.get('/newTrade', isLoggedIn, controller.new);

//POST /trades: create a new trade
router.post('/', isLoggedIn, validateTrade, controller.create);

//GET /trades/:id: send details of trade identified by id
router.get('/:id', validateId, controller.show);

// GET /trades/:id/edit: send html form for editing an existing trade
router.get('/:id/edit', validateId, isLoggedIn, isCreator, controller.edit);

//PUT /trades/:id: update the trade identified by id
router.put('/:id', validateId, isLoggedIn, isCreator, validateTrade, controller.update);

//DELETE /trades/:id, delete the trade identified by id
router.delete('/:id', validateId, isLoggedIn, isCreator, controller.delete);

//GET /trades/:id/trade: send info for user to initiate a trade for the item
router.get('/:id/trade', validateId, isLoggedIn, controller.trading);

module.exports = router;