import 'package:flutter_dotenv/flutter_dotenv.dart';

class Configure {
  static String get razorpayKeyId =>
      dotenv.env["RAZORPAY_KEY_ID"] ?? "razorpay_key_id";
  static String get razorpaySecretKey =>
      dotenv.env["RAZORPAY_SECRET_KEY"] ?? "razorpay_secret_key";
}
