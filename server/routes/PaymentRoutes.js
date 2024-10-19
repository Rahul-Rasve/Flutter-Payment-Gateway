const express = require("express");
const { createPaymentOrder } = require("../controllers/PaymentController");

const router = express.Router();

router.post("/order", createPaymentOrder);

module.exports = router;
