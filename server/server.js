const express = require('express');
const mongoose = require('mongoose');

const URL = "mongodb+srv://vaibhav:vaibhav@cluster0.uavseiu.mongodb.net/?retryWrites=true&w=majority";

mongoose.connect(URL).then(()=>{
    console.log("Connected to DB successfully");
}).catch((e)=>{
    console.log(e);
});


const PORT = process.env.PORT | 5000;
const app = express();
app.listen(PORT , "0.0.0.0" , ()=> {
    console.log(`*.* hey , listening to port ${PORT}`);
});
