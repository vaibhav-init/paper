const express = require('express');
const Document = require('../models/doc_model');
const docRouter = express.Router();
const auth = require('../middlewares/auth_middleware');

docRouter.post('/doc/create' ,auth , async (req, res)=>{

    try{ 
        const {createdAt}= req.body;
        let document = new Document({
            uid: req.user, 
            title: 'Untitled Paper',
            createdAt,
        });
        document = await document.save();
        res.json(document);
        
    }
    catch(e){
        res.status(500).json({
            error: e.message
        });

    }

});
module.exports = docRouter; 