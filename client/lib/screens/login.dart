import 'package:client/screens/signup.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              const SizedBox(height: 25),
              const TextField(
                key: Key("Email-Field"),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              const TextField(
                key: Key("Password-Field"),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                key: const Key("Login-Button"),
                onPressed: () {
                  debugPrint("Login Button Pressed");
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
        ),
      ),
    );
  }
}
