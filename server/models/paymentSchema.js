const mongoose = require("mongoose");

const PaymentSchema = new mongoose.Schema(
	{
		userId: {
			type: mongoose.Schema.ObjectId,
			ref: "User",
			required: true,
		},
		paymentType: {
			type: String,
			enum: ["DEPOSIT", "WITHDRAWAL", "BUY_GOLD", "SELL_GOLD"],
			required: true,
		},
		amount: {
			type: Number,
			required: true,
		},
		goldQuantity: {
			type: Number,
			required: true,
			default: 0,
		},
		goldPrice: {
			type: Number,
			required: true,
			default: 0,
		},
		status: {
			type: String,
			required: true,
			enum: ["COMPLETED", "FAILED", "PENDING"],
			default: "PENDING",
		},
		razorpayPaymentId: {
			type: String,
		},
		razorpayOrderId: {
			type: String,
		},
	},
	{
		timestamps: true,
	}
);

module.exports = mongoose.model("Payment", PaymentSchema);
