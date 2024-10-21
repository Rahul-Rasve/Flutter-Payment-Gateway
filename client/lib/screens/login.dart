import 'package:client/bloc/login_bloc.dart';
import 'package:client/models/user_model.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/portfolio.dart';
import 'package:client/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              debugPrint("Login Success");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Login Success"),
                  showCloseIcon: true,
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  // builder: (_) => HomeScreen(
                  //   user: UserModel(
                  //     userId: state.user.userId,
                  //     name: state.user.name,
                  //     email: state.user.email,
                  //     portfolio: state.user.portfolio,
                  //   ),
                  // ),
                  builder: (_) => PortfolioScreen(userId: state.user.userId),
                ),
                (route) => false,
              );
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  showCloseIcon: true,
                ),
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      key: const Key("Email-Field"),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      key: const Key("Password-Field"),
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your Password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 25),
                    state is LoginLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            key: const Key("Login-Button"),
                            onPressed: () {
                              debugPrint("Login Button Pressed");
                              final String email = _emailController.text;
                              final String password = _passwordController.text;

                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("All fields are required"),
                                  ),
                                );
                              } else {
                                BlocProvider.of<LoginBloc>(context).add(
                                  LoginButtonPressed(
                                    email: email,
                                    password: password,
                                  ),
                                );
                              }
                            },
                            child: const Text("Login"),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          key: const Key("Register-Button"),
                          onPressed: () {
                            debugPrint("Register Button Pressed");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignUpScreen()));
                          },
                          child: const Text("Register"),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
