const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const patientSchema = new Schema({
    num_id: {type: String, required: [true, 'ID is required']},
    first_name: {type: String, required: [true, 'First name is required']},
    last_name: {type: String, required: [true, 'Last name is required']},
    sex: {type: String, required: [true, 'Sex is required']},
    age: {type: String, required: [true, 'Age is required']},
    address: {type: String, required: [true, 'Address is required']},
    phone: {type: String, required: [true, 'Phone number is required']},
    email: {type: String, required: [true, 'Email address is required']},
    insurance: {type: String},
    insurance_id: {type: String},
    //creator: {type: Schema.Types.ObjectId, ref: 'User'}
});

module.exports = mongoose.model('Patient', patientSchema);