import 'package:client/bloc/home_bloc.dart';
import 'package:client/bloc/payment_bloc.dart';
import 'package:client/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final UserModel? user;
  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => HomeBloc(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name : ${widget.user?.name}",
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "Portfolio : ${widget.user?.portfolio} rupees",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 200),
              TextField(
                key: const Key("Amout-field"),
                controller: _amountController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Amount',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              BlocConsumer<PaymentBloc, PaymentState>(
                listener: (context, state) {
                  if (state is PaymentFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Payment Failed!")),
                    );
                  } else if (state is PaymentSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Payment Successfull!")),
                    );
                  }
                },
                builder: (context, state) => state is PaymentLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          context.read<PaymentBloc>().add(
                                CreatePaymentOrder(
                                  amount:
                                      double.tryParse(_amountController.text) ??
                                          0.0,
                                  userId: widget.user?.userId ?? "",
                                ), // Amount in INR
                              );
                        },
                        child: const Text('Pay Now'),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
