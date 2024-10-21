import 'package:client/bloc/portfolio_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellGoldDialog extends StatefulWidget {
  final String userId;
  const SellGoldDialog({super.key, required this.userId});

  @override
  State<SellGoldDialog> createState() => _SellGoldDialogState();
}

class _SellGoldDialogState extends State<SellGoldDialog> {
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sell Gold'),
      content: TextField(
        controller: _quantityController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Quantity',
          prefixText: 'Gm ', //grams
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final quantity = double.tryParse(_quantityController.text);
            if (quantity != null && quantity > 0) {
              context
                  .read<PortfolioBloc>()
                  .add(SellGold(quantity, widget.userId));
              Navigator.pop(context);
            }
          },
          child: const Text('Sell'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
