require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

//connect to database
mongoose
	.connect(process.env.MONGODB_URL)
	.then(() => {
		console.log("Database connected");
	})
	.catch((err) => {
		console.log(err);
	});

//create express server
const app = express();

//middleware
app.use(cors());
app.use(express.json());

//routes
app.use("/api/user/auth", require("./routes/UserRoutes"));

//declare port
app.listen(process.env.PORT, () => {
	console.log(`Server is running on port ${process.env.PORT}`);
});
