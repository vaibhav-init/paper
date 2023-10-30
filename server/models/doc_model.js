const mongoose = require('mongoose');

const docSchema = mongoose.Schema({
    uid:{
        required: true, 
        type: String
    },
    createdAt:{
        required: true, 
        type: Number
    },
    title:{
        required: true, 
        type: String, 
        trim: true
    },
    content:{
        type: Array, 
        default: [],
    },

});
const Document = mongoose.model("Document" , docSchema);

module.exports = Document;