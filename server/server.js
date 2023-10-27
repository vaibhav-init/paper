const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const cors = require('cors');

const URL = "mongodb+srv://vaibhav:vaibhav@cluster0.uavseiu.mongodb.net/?retryWrites=true&w=majority";

mongoose.connect(URL).then(() => {
    console.log("Connected to DB successfully");
}).catch((e) => {
    console.log(e);
});

const PORT = 5000; // Set the port to 5000 for local development
const app = express();

app.use(express.json());
app.use(cors());
app.use(authRouter);

app.listen(PORT, "0.0.0.0", () => {
    console.log(`*.* hey, listening to port ${PORT}`);
});
