const express = require("express");
const {
	createPaymentOrder,
	verifyPayment,
} = require("../controllers/PaymentController");

const router = express.Router();

router.post("/order", createPaymentOrder);
router.post("/verify-payment", verifyPayment);

module.exports = router;
