const mongoose = require("mongoose");

const registrationSchema = new mongoose.Schema({
    eventID : {type: String, required: true},
    studentName : {type: String, required: true},
    regNo : {type: Number, required: true},
    department : {type: String, required: true},
    year : {type: String, required: true},
    section : {type: String, required: true},
})

const RegistrationModel = mongoose.model('registration',registrationSchema);

module.exports = RegistrationModel;