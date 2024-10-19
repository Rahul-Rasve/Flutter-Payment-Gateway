import 'package:client/bloc/signup_bloc.dart';
import 'package:client/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignUpBloc(),
        child: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Sign Up Success: Please login"),
                ),
              );
              Navigator.pop(context);
            } else if (state is SignUpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
          child: BlocBuilder<SignUpBloc, SignUpState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      key: const Key("Name-Field"),
                      controller: _nameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        hintText: "Enter your Full Name",
                        border: OutlineInputBorder(),
                      ),
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
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your Password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 25),
                    state is SignUpLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            key: const Key("Sign-Up-Button"),
                            onPressed: () {
                              final String name = _nameController.text;
                              final String email = _emailController.text;
                              final String password = _passwordController.text;

                              if (name.isEmpty ||
                                  email.isEmpty ||
                                  password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("All fields are required"),
                                  ),
                                );
                              } else {
                                BlocProvider.of<SignUpBloc>(context).add(
                                  SignUpButtonPressed(
                                    name: name,
                                    email: email,
                                    password: password,
                                  ),
                                );
                              }
                            },
                            child: const Text("Sign Up"),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          key: const Key("Login-Button"),
                          onPressed: () {
                            debugPrint("Login Button Pressed");
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()));
                          },
                          child: const Text("Login"),
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
