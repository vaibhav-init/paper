const express = require('express');
const User = require('../models/user_model');

const authRouter = express.Router();

authRouter.post('/api/signup' , async (req , res)=> {
    try{
       
        const {name , email , profile} = req.body;
        let user = await User.findOne({email});
        
        if(!user){
            
            user = new User({
                name: name, 
                email: email, 
                profile: profile,
            });
            user = await user.save();
            
        }
        res.json({user});

        
    }
    catch(e){
        // res.status(500).json({error: e.message});
        console.log(e);
    }

});

module.exports = authRouter;