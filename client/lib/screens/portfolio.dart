// lib/screens/portfolio_screen.dart
import 'package:client/bloc/portfolio_bloc.dart';
import 'package:client/components/dialogs/buy_gold.dart';
import 'package:client/components/dialogs/deposit.dart';
import 'package:client/components/dialogs/sell_gold.dart';
import 'package:client/models/payment_model.dart';
import 'package:client/models/user_portfolio_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PortfolioScreen extends StatelessWidget {
  final String userId;
  const PortfolioScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PortfolioBloc()..add(LoadPortfolio(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Portfolio'),
        ),
        body: BlocConsumer<PortfolioBloc, PortfolioState>(
          listener: (context, state) {
            if (state is PortfolioError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is PortfolioLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PortfolioLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PortfolioBloc>().add(LoadPortfolio(userId));
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PortfolioSummaryCard(portfolio: state.portfolio),
                        const SizedBox(height: 16),
                        _ActionButtons(
                          userId: userId,
                        ),
                        const SizedBox(height: 16),
                        _GoldHoldingsCard(
                            goldHoldings: state.portfolio.goldHoldings),
                        const SizedBox(height: 16),
                        _RecentTransactions(transactions: state.transactions),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }
}

class _PortfolioSummaryCard extends StatelessWidget {
  final UserPortfolio portfolio;

  const _PortfolioSummaryCard({required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Portfolio Value',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '₹${portfolio.totalValue.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Available Cash'),
                    Text(
                      '₹${portfolio.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Gold Value'),
                    Text(
                      '₹${portfolio.goldHoldings.currentValue.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String userId;

  const _ActionButtons({required this.userId});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _showDepositDialog(context),
          child: const Text('Deposit'),
        ),
        ElevatedButton(
          onPressed: () => _showBuyGoldDialog(context),
          child: const Text('Buy Gold'),
        ),
        ElevatedButton(
          onPressed: () => _showSellGoldDialog(context),
          child: const Text('Sell Gold'),
        ),
      ],
    );
  }

  void _showDepositDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DepositDialog(
        userId: userId,
      ),
    );
  }

  void _showBuyGoldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BuyGoldDialog(
        userId: userId,
      ),
    );
  }

  void _showSellGoldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SellGoldDialog(
        userId: userId,
      ),
    );
  }
}

class _GoldHoldingsCard extends StatelessWidget {
  final GoldHoldings goldHoldings;

  const _GoldHoldingsCard({required this.goldHoldings});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gold Holdings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _GoldInfoItem(
                  label: 'Quantity',
                  value: '${goldHoldings.quantity.toStringAsFixed(3)} g',
                ),
                _GoldInfoItem(
                  label: 'Avg. Buy Price',
                  value: '₹${goldHoldings.buyPrice.toStringAsFixed(2)}',
                ),
                _GoldInfoItem(
                  label: 'Current Price',
                  value: '₹${goldHoldings.globalPrice.toStringAsFixed(2)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GoldInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _GoldInfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  final List<PaymentModel> transactions;

  const _RecentTransactions({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return Card(
              child: ListTile(
                leading: _getTransactionIcon(transaction.type),
                title: Text(_getTransactionTitle(transaction)),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy HH:mm')
                      .format(transaction.createdAt),
                ),
                trailing: Text(
                  '₹${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: _getAmountColor(transaction.type),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Icon _getTransactionIcon(String type) {
    switch (type) {
      case 'DEPOSIT':
        return const Icon(Icons.add_circle, color: Colors.green);
      case 'WITHDRAWAL':
        return const Icon(Icons.remove_circle, color: Colors.red);
      case 'BUY_GOLD':
        return const Icon(Icons.trending_up, color: Colors.orange);
      case 'SELL_GOLD':
        return const Icon(Icons.trending_down, color: Colors.blue);
      default:
        return const Icon(Icons.swap_horiz);
    }
  }

  String _getTransactionTitle(PaymentModel transaction) {
    switch (transaction.type) {
      case 'DEPOSIT':
        return 'Deposit';
      case 'WITHDRAWAL':
        return 'Withdrawal';
      case 'BUY_GOLD':
        return 'Bought ${transaction.goldQuantity.toStringAsFixed(3)} g Gold';
      case 'SELL_GOLD':
        return 'Sold ${transaction.goldQuantity.toStringAsFixed(3)} g Gold';
      default:
        return 'Transaction';
    }
  }

  Color _getAmountColor(String type) {
    switch (type) {
      case 'DEPOSIT':
      case 'SELL_GOLD':
        return Colors.green;
      case 'WITHDRAWAL':
      case 'BUY_GOLD':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
