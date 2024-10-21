# Flutter and Node.js Payment Integration Project

This project consists of a **Flutter** client and a **Node.js** server. The project integrates with **Razorpay** for payment processing, and **MongoDB** is used for the backend database.

## Table of Contents
- [Flutter Setup](#flutter-setup)
- [Node.js Setup](#nodejs-setup)
- [Technologies Used](#technologies-used)

---

## Flutter Setup

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/Rahul-Rasve/Flutter-Payment-Gateway.git
   cd client
   ```

2. **Install Flutter Dependencies:**

   Run the following command in the `client/` directory:

   ```bash
   flutter pub get
   ```

3. **Create an `.env` file:**

   In the `client/` directory, create a file named `.env` and add the following environment variables:

   ```
   RAZORPAY_KEY_ID=<your-razorpay-key>
   RAZORPAY_SECRET_KEY=<your-razorpay-secret-key>
   ```

4. **Run the Flutter App:**

   After setting up the environment, you can run the app using:

   ```bash
   flutter run
   ```

---

## Node.js Setup

1. **Navigate to the `server/` directory:**

   ```bash
   cd server
   ```

2. **Install Node.js Dependencies:**

   Run the following command to install the necessary dependencies:

   ```bash
   npm install
   ```

3. **Create an `.env` file:**

   In the `server/` directory, create a file named `.env` and add the following environment variables:

   ```
   RAZORPAY_KEY_ID=<your-razorpay-key>
   RAZORPAY_SECRET_KEY=<your-razorpay-secret-key>
   PORT=<your-port>
   MONGODB_URL=<your-mongodb-url>
   ```

4. **Start the Server:**

   To start the server in development mode, run the following command:

   ```bash
   npm run dev
   ```

---

## Technologies Used

### Flutter:
- Dart
- Flutter SDK
- Razorpay SDK Integration

### Node.js:
- Express.js
- Razorpay Node SDK
- MongoDB for database
- dotenv for environment variables

---

## Attention!!!

 Main branch is lock and is **Read-Only**, if you wan to contribute, create a Pull-Request -> get it reviewd -> merge it.
