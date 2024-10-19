const mongoose = require("mongoose");

const User = mongoose.Schema(
	{
		name: {
			type: String,
			required: true,
		},
		email: {
			type: String,
			required: true,
			unique: true,
		},
		portfolio: {
			type: String,
			required: true,
			default: "0",
		},
		password: {
			type: String,
			required: true,
		},
	},
	{ timestamps: true }
);

module.exports = mongoose.model("User", User);
