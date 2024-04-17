const express = require('express');
const controller = require('../controllers/userController');
const {isLoggedIn, isGuest} = require('../middlewares/auth');
const {loginLimiter} = require('../middlewares/rateLimiters');
const {validateSignUp, validateLogin, validateResult} = require('../middlewares/validator');
const router = express.Router();

// GET /users/new: sign up page
router.get('/new', isGuest, controller.new);

// POST /users: create new user
router.post('/', isGuest, validateSignUp, validateResult, controller.create);

// GET /users/login: login page
router.get('/login', isGuest, controller.login);

// POST /users/login: log in user
router.post('/login', loginLimiter, isGuest, validateLogin, controller.loggedin);

// GET /users/profile: show user's profile page
router.get('/profile', isLoggedIn, controller.profile);

// GET /users/logout: log out user
router.get('/logout', isLoggedIn, controller.logout);

module.exports = router;