const Razorpay = require("razorpay");
const Payment = require("../models/paymentSchema");

const razorpay = new Razorpay({
	key_id: process.env.RAZORPAY_KEY_ID,
	key_secret: process.env.RAZORPAY_SECRET_KEY,
});

const createPaymentOrder = async (req, res) => {
	try {
		const options = {
			amount: req.body.amount * 100,
			currency: "INR",
			receipt: "receipt_" + Date.now(),
		};

		const order = await razorpay.orders.create(options);

		const newPayment = await Payment({
			paymentId: order.id,
			amount: order.amount,
			currency: order.currency,
			status: order.status,
			userId: req.body.userId,
		}).save();

		return res.status(201).send({
			success: true,
			message: "Payment created successfully",
			data: newPayment,
		});
	} catch (error) {
		return res.status(500).send({
			success: false,
			message: "Error creating payment order",
			data: error,
		});
	}
};

const verifyPayment = async (req, res) => {
	try {
		const { razorpay_signature, razorpay_payment_id, razorpay_order_id } =
			req.body;

		//verify signature
		const generated_signature = crypto
			.createHmac("sha256", process.env.RAZORPAY_SECRET_KEY)
			.update(razorpay_order_id + "|" + razorpay_payment_id)
			.digest("hex");

		if (generated_signature !== razorpay_signature) {
			return res.status(400).send({
				success: false,
				message: "Invalid signature sent!",
			});
		}

		await Payment.findOneAndUpdate(
			{ paymentId: razorpay_payment_id },
			{ status: "PAID" }
		);

		return res.status(200).send({
			success: true,
			message: "Payment verified successfully",
		});
	} catch (error) {
		return res.status(500).send({
			success: false,
			message: "Error verifying payment order",
			data: error,
		});
	}
};

module.exports = {
	createPaymentOrder,
	verifyPayment,
};
