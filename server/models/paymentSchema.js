const mongoose = require("mongoose");

const PaymentSchema = new mongoose.Schema(
	{
		paymentId: {
			type: String,
			required: true,
		},
		amount: {
			type: Number,
			required: true,
		},
		currency: {
			type: String,
			required: true,
		},
		status: {
			type: String,
			required: true,
		},
		userId: {
			type: mongoose.Schema.ObjectId,
			ref: "User",
			required: true,
		},
	},
	{
		timestamps: true,
	}
);

module.exports = mongoose.model("Payment", PaymentSchema);
