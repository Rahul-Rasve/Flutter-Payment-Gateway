const express = require("express");
const {
	createPaymentOrder,
	verifyPayment,
	handleDeposits,
	getGoldPrice,
	handleBuyGold,
	handleSellGold,
	getTransactionHistory,
	getPortfolioStats,
} = require("../controllers/PaymentController");

const router = express.Router();

router.post("/order", createPaymentOrder);
router.post("/verify-payment", verifyPayment);
router.post("/deposit", handleDeposits);
router.post("/buy-gold", handleBuyGold);
router.post("/sell-gold", handleSellGold);
router.get("/gold-price", getGoldPrice);
router.get("/transaction-history", getTransactionHistory);
router.get("/portfolio-stats", getPortfolioStats);

module.exports = router;
