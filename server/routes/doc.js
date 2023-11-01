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

docRouter.post('/doc/update/title' ,auth , async (req, res)=>{

    try{ 
        
        
        const {id , title}= req.body;
        const document = await Document.findByIdAndUpdate(id, {title});
        res.json(document);        
    }
    catch(e){
        res.status(500).json({
            error: e.message + "Backend Error"
        });

    }

});

docRouter.get('/doc/:id' , auth , async(req , res)=> {
    try{
        const  document = await Document.findById(req.params.id);
        res.json(document);


    }catch(e){
        res.status(500).json({
            error: e.message + "Backend Error"
        });

    }

});

docRouter.delete('/delete/:id', auth, async (req, res) => {
    try {
      const documentId = req.params.id;
      const deletedDocument = await Document.findByIdAndRemove(documentId);
  
      if (deletedDocument) {
        console.log(`document with id : ${documentId} deleted`);
        res.json({ message: 'Document deleted successfully' });
      } else {
        console.log('Nahi ho paya delete ');
        res.status(404).json({ error: 'Document not found' });
      }
    } catch (e) {
      res.status(500).json({
        error: e.message + ' Backend Error',
      });
    }
  });
  
module.exports = docRouter; 