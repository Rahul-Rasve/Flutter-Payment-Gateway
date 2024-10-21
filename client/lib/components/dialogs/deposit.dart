import 'package:client/bloc/portfolio_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepositDialog extends StatefulWidget {
  final String userId;
  const DepositDialog({super.key, required this.userId});

  @override
  State<DepositDialog> createState() => _DepositDialogState();
}

class _DepositDialogState extends State<DepositDialog> {
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Deposit Amount'),
      content: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Amount (₹)',
          prefixText: '₹ ',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(_amountController.text);
            if (amount != null && amount > 0) {
              context
                  .read<PortfolioBloc>()
                  .add(CreateDeposit(amount, widget.userId));
              Navigator.pop(context);
            }
          },
          child: const Text('Deposit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
