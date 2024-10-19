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
        }

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
        
    }
}

module.exports = {
    createPaymentOrder,
};
