const userSchema = require("../models/userSchema");

const signUpController = async (req, res) => {
	try {
		const { name, email, password } = req.body;

		const existingUser = await userSchema.findOne({ email });

		if (existingUser) {
			return res.status(400).send({
				success: false,
				message: "User already exists",
			});
		}

		const newUser = await userSchema({
			name,
			email,
			password,
		}).save();

		newUser.password = undefined;

		return res.status(201).send({
			success: true,
			message: "User created successfully",
			data: newUser,
		});
	} catch (error) {
		console.error(error);
		return res.status(500).send({
			success: false,
			message: "Some error occurred in Sign-Up-Controller",
			error,
		});
	}
};

const loginController = async (req, res) => {
	try {
		const { email, password } = req.body;

		//serch user
		const user = await userSchema.findOne({ email });
		if (!user) {
			return res.status(500).send({
				success: false,
				message: "No user found with this email!",
			});
		}

		//check password
		const isMatch = user.password === password;

		if (!isMatch) {
			return res.status(400).send({
				success: false,
				message: "Wrong Password!",
			});
		}

		user.password = undefined;

		return res.status(200).send({
			success: true,
			message: "Login Successfull",
			user,
		});
	} catch (error) {
		console.error(error);
		return res.status(500).send({
			success: false,
			message: "Some error occurred in Login-Controller",
			error,
		});
	}
};

module.exports = { signUpController, loginController };
