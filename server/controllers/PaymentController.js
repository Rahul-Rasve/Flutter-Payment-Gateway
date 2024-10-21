const Razorpay = require("razorpay");
const Payment = require("../models/paymentSchema");
const crypto = require("crypto");
const User = require("../models/userSchema");

const razorpay = new Razorpay({
	key_id: process.env.RAZORPAY_KEY_ID,
	key_secret: process.env.RAZORPAY_SECRET_KEY,
});

const createPaymentOrder = async (req, res) => {
	try {
		const options = {
			amount: req.body.amount,
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

		const payment = await Payment.findOneAndUpdate(
			{ razorpayOrderId: razorpay_order_id },
			{ status: "PAID", razorpayPaymentId: razorpay_payment_id }
		);

		await User.findByIdAndUpdate(payment.userId, {
			$inc: { goldHoldings: payment.amount },
		});

		return res.status(200).send({
			success: true,
			message: "Payment verified successfully",
		});
	} catch (error) {
		console.error("Error verifying payment:", error);
		return res.status(500).send({
			success: false,
			message: "Error verifying payment order",
		});
	}
};

const handleDeposits = async (req, res) => {
	try {
		const { amount, userId } = req.body;
		const options = {
			amount: amount,
			currency: "INR",
			receipt: "receipt_" + Date.now(),
		};

		const order = await razorpay.orders.create(options);

		const newPayment = await Payment({
			userId: userId,
			type: "DEPOSIT",
			amount: amount,
			status: "PENDING",
			razorpayOrderId: order.id,
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
		});
	}
};

const getGoldPrice = async (req, res) => {
	const price = 7000 + Math.random() * 1000;

	return res.status(200).send({
		success: true,
		message: "Gold price fetched successfully",
		goldPrice: price,
	});
};

const handleBuyGold = async (req, res) => {
	try {
		const { amount, userId } = req.body;

		const user = await User.findById(userId);

		if (user.portfolio < amount) {
			return res.status(400).send({
				success: false,
				message: "Insufficient balance",
			});
		}

		//update user portfolio
		const currentGoldPrice = 7000 + Math.random() * 1000;
		const quantity = amount / currentGoldPrice;

		user.goldHoldings.quantity += quantity;
		user.portfolio -= amount;

		const newBuyPrice =
			(user.goldHoldings.quantity * user.goldHoldings.buyPrice + amount) /
			user.goldHoldings.quantity;

		user.goldHoldings.buyPrice = newBuyPrice;

		await user.save();

		//add new payment
		const payment = await Payment({
			userId: userId,
			type: "BUY_GOLD",
			amount: amount,
			goldQuantity: quantity,
			goldPrice: currentGoldPrice,
			status: "COMPLETED",
		}).save();

		//response data
		const userData = {
			type: payment.type,
			amount: payment.amount,
			goldQuantity: payment.goldQuantity,
			goldPrice: payment.goldPrice,
			status: payment.status,
			newBalance: user.portfolio,
			newGoldQuantity: user.goldHoldings.quantity,
		};

		return res.status(200).send({
			success: true,
			message: "Gold bought successfully",
			data: userData,
		});
	} catch (error) {
		return res.status(500).send({
			success: false,
			message: "Error buying gold",
		});
	}
};

const handleSellGold = async (req, res) => {
	try {
		const { quantity, userId } = req.body;
		const user = await User.findById(userId);

		if (user.goldHoldings.quantity < quantity) {
			return res.status(400).send({
				success: false,
				message: "Insufficient gold quantity",
			});
		}

		//calculate amount to be deducted
		const currentGoldPrice = 7000 + Math.random() * 1000;
		const amount = quantity * currentGoldPrice;

		//update user portfolio
		user.portfolio += amount;
		user.goldHoldings.quantity -= quantity;
		if (user.goldHoldings.quantity === 0) {
			user.goldHoldings.buyPrice = 0;
		}

		//add new payment
		const payment = await Payment({
			userId: userId,
			type: "SELL_GOLD",
			amount: amount,
			goldQuantity: quantity,
			goldPrice: currentGoldPrice,
			status: "COMPLETED",
		}).save();

		//response data
		const userData = {
			type: payment.type,
			amount: payment.amount,
			goldQuantity: payment.goldQuantity,
			goldPrice: payment.goldPrice,
			status: payment.status,
			newBalance: user.portfolio,
			newGoldQuantity: user.goldHoldings.quantity,
		};

		return res.status(200).send({
			success: true,
			message: "Gold sold successfully",
			data: userData,
		});
	} catch (error) {
		return res.status(500).send({
			success: false,
			message: "Error selling gold",
		});
	}
};

const getTransactionHistory = async (req, res) => {
	try {
		const { userId } = req.body;
		const user = await User.findById(userId);

		const payments = await Payment.find({ userId: userId }).sort({
			createdAt: -1,
		});

		return res.status(200).send({
			success: true,
			message: "Transaction history fetched successfully",
			data: payments,
		});
	} catch (error) {
		return res.status(500).send({
			success: false,
			message: "Error getting transaction history",
		});
	}
};

const getPortfolioStats = async (req, res) => {
	try {
		const user = await User.findById(req.body.userId);
		const currentGoldPrice = 7000 + Math.random() * 1000;

		const userPorfolio = {
			amount: user.portfolio,
			Gold: {
				quantity: user.goldHoldings.quantity,
				buyPrice: user.goldHoldings.globalPrice,
				globalPrice: currentGoldPrice,
				currentValue: user.goldHoldings.quantity * currentGoldPrice,
			},
			total: user.portfolio * (user.goldHoldings.quantity * currentGoldPrice),
		};

		return res.status(200).send({
			success: true,
			message: "Portfolio stats fetched successfully",
			data: userPorfolio,
		});
	} catch (error) {
		return res.status(500).send({
			success: false,
			message: "Error getting portfolio stats",
		});
	}
};

module.exports = {
	createPaymentOrder,
	verifyPayment,
	handleDeposits,
	getGoldPrice,
	handleBuyGold,
	handleSellGold,
	getTransactionHistory,
	getPortfolioStats,
};
