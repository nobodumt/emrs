const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const watchSchema = new Schema({
    watcher: {type: Schema.Types.ObjectId, ref: 'User', required: [true, 'watcher id (user id) is required']},
    tradeId: {type: Schema.Types.ObjectId, ref: 'Trade', required: [true, 'trade id is required']},
    name: {type: String, required: [true, 'name is required']},
    category: {type: String, required: [true, 'category is required']},
    status: {type: String, required: [true, 'status is required']}
});

module.exports = mongoose.model('Watch', watchSchema);