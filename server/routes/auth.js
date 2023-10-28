const express = require('express');
const User = require('../models/user_model');
    
const authRouter = express.Router();
const jwt = require('jsonwebtoken');
const auth = require('../middlewares/auth_middleware');

authRouter.post("/api/signup" , async (req , res)=> {
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
        const token = jwt.sign({id: user._id}, "password");
        res.json({user ,token });        
    }
    catch(e){
        res.status(500).json({error: e.message});
        
    }



});

authRouter.get("/" , auth ,  async (req , res)=> {
    const user = await User.findById(req.user);
    console.log("*CUSTOM TESTING POINT*  " + req.token);
    res.json({ user , token: req.token});

});

module.exports = authRouter;