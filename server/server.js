const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const cors = require('cors');
const docRouter = require('./routes/doc');
const http = require('http');
const Document = require("./models/doc_model");

const URL = "mongodb+srv://vaibhav:vaibhav@cluster0.uavseiu.mongodb.net/?retryWrites=true&w=majority";
const app = express();

app.use(express.json());
app.use(cors());
app.use(authRouter);
app.use(docRouter); 
var server = http.createServer(app);
var io= require('socket.io')(server);

mongoose.connect(URL).then(() => {
    console.log("Connected to DB successfully");
}).catch((e) => {
    console.log(e);
});
//socket io part 
io.on('connection' ,(socket)=> {
   
    socket.on('join' , (documentId)=>{
        socket.join(documentId);
        console.log('Joined');
    });
    socket.on('typing' , (data)=> {
        socket.broadcast.to(data.room).emit('changes' , data);
        
    })
    socket.on('save', (data)=> {
        saveData(data);

    })
});

const saveData = async (data)=> {
    let document= await Document.findById(data.room);
    document.content= data.delta;
    document = await document.save();

};
const PORT = 5000;
server.listen(PORT, "0.0.0.0", () => {
    console.log(`*.* hey, listening to port ${PORT}`);
});
