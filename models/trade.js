const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const tradeSchema = new Schema({
    name: {type: String, required: [true, 'name is required']},
    status: {type: String, required: [true, 'status is required'], default: 'Upcoming'},
    details: {type: String, required: [true, 'details are required']},
    category: {type: String, required: [true, 'category is required']},
    size: {type: String, required: [true, 'size is required']},
    color: {type: String, required: [true, 'color is required']},
    condition: {type: String},
    //image: {type: String, required: [true, 'image is required'], default: "https://upload.wikimedia.org/wikipedia/commons/3/3f/Placeholder_view_vector.svg"},
    creator: {type: Schema.Types.ObjectId, ref: 'User'}
});

module.exports = mongoose.model('Trade', tradeSchema);