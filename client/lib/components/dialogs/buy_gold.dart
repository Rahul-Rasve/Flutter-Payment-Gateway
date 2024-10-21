import 'package:client/bloc/portfolio_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyGoldDialog extends StatefulWidget {
  final String userId;
  const BuyGoldDialog({super.key, required this.userId});

  @override
  State<BuyGoldDialog> createState() => _BuyGoldDialogState();
}

class _BuyGoldDialogState extends State<BuyGoldDialog> {
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Buy Gold'),
      content: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Quantity (in grams)',
          prefixText: 'Gm',
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
                  .add(BuyGold(amount, widget.userId));
              Navigator.pop(context);
            }
          },
          child: const Text('Buy'),
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
