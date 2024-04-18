const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const tradeSchema = new Schema({
    name: {type: String, required: [true, 'name is required']},
    status: {type: String, required: [true, 'status is required'], default: 'Upcoming'}, // appointment status
    details: {type: String, required: [true, 'details are required']},
    category: {type: String, required: [true, 'category is required']}, // physician
    size: {type: String, required: [true, 'size is required']}, // date and time
    color: {type: String, required: [true, 'color is required']}, // phone number
    creator: {type: Schema.Types.ObjectId, ref: 'User'}
});

module.exports = mongoose.model('Trade', tradeSchema);