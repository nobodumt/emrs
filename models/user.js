const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const bcrypt = require('bcrypt');

const userSchema = new Schema({
    firstName: {type: String, required: [true, 'first name is required']},
    lastName: {type: String, required: [true, 'last name is required']},
    email: { type: String, required: [true, 'email address is required'], unique: [true, 'There is already an user account with this email address.'] },
    password: { type: String, required: [true, 'password is required'] },
    //image: {type: String, required: [true, 'image is required'], default: "https://upload.wikimedia.org/wikipedia/commons/3/3f/Placeholder_view_vector.svg"}
    // TODO: might add the ability to upload a patient image in the future
});

userSchema.pre('save', function(next){
    let user = this;
    if(!user.isModified('password')) {
        return next();
    }
    bcrypt.hash(user.password, 10)
    .then(hash=>{
        user.password = hash;
        next();
    })
    .catch(err=>next(err));
});

userSchema.methods.comparePassword = function(loginPassword) {
    return bcrypt.compare(loginPassword, this.password);
}

module.exports = mongoose.model('User', userSchema);