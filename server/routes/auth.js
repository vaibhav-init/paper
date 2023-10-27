const express = require('express');
const User = require('../models/user_model');

const authRouter = express.Router();

authRouter.post('/api/signup' , async (req , res)=> {
    try{
        console.log("Start Debug");
        const {email , name , profile} = req.body;
        let user = await User.findOne({email});
        console.log("Start Debug");
        if(!user){
            console.log("Start Debug");
            user = new User({
                name: name, 
                email: email, 
                profile: profile,
            });
            user = await user.save();
            console.log("Start Debug");
        }
        res.json({user});

        
    }
    catch(e){
        console.log("Start pappu");
        res.status(500).json({error: e.message});
    }

});

module.exports = authRouter;