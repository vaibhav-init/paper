const express = require('express');
const Document = require('../models/doc_model');
const docRouter = express.Router();
const auth = require('../middlewares/auth_middleware');

docRouter.post('/doc/create' ,auth , async (req, res)=>{

    try{ 
        
        
        const {createdAt}= req.body;
       
      
        let document = new Document({
            uid: req.user, 
            title: "Untitled Paper",
            createdAt: createdAt,
        });
        document = await document.save();
        res.json(document);        
    }
    catch(e){
        res.status(500).json({
            error: e.message + "Backend Error"
        });

    }

});

docRouter.get('/doc/my' , auth , async(req , res)=> {
    try{
        let documents = await Document.find({uid: req.user});
        res.json(documents);


    }catch(e){
        reitems.status(500).json({
            error: e.message + "Backend Error"
        });

    }

});
module.exports = docRouter; 