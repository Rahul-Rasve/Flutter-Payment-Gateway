const mongoose = require("mongoose");

const UserSchema = mongoose.Schema(
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
		password: {
			type: String,
			required: true,
		},
		portfolio: {
			type: Number,
			default: 0,
		},
		goldHoldings: {
			quantity: {
				type: Number,
				default: 0,
			},
			buyPrice: {
				type: Number,
				default: 0,
			},
		},
	},
	{ timestamps: true }
);

module.exports = mongoose.model("User", UserSchema);
