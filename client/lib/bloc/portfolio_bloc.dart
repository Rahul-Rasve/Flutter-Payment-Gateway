import 'package:client/api/api_client.dart';
import 'package:client/config/config.dart';
import 'package:client/models/api_response.dart';
import 'package:client/models/payment_model.dart';
import 'package:client/models/user_portfolio_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

//---------------EVENTS
abstract class PortfolioEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPortfolio extends PortfolioEvent {
  final String userId;
  LoadPortfolio(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoadTransactions extends PortfolioEvent {
  final String userId;
  LoadTransactions(this.userId);

  @override
  List<Object> get props => [userId];
}

class CreateDeposit extends PortfolioEvent {
  final String userId;
  final double amount;
  CreateDeposit(this.amount, this.userId);
}

class BuyGold extends PortfolioEvent {
  final String userId;
  final double amount;
  BuyGold(this.amount, this.userId);
}

class SellGold extends PortfolioEvent {
  final String userId;
  final double quantity;
  SellGold(this.quantity, this.userId);
}

class UpdatePortfolio extends PortfolioEvent {
  final String userId;
  UpdatePortfolio(this.userId);
}

//---------------STATES
abstract class PortfolioState {}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  final UserPortfolio portfolio;
  final List<PaymentModel> transactions;
  PortfolioLoaded(this.portfolio, this.transactions);
}

class PortfolioError extends PortfolioState {
  final String message;
  PortfolioError(this.message);
}

// lib/blocs/portfolio/portfolio_bloc.dart
class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final ApiClient api = ApiClient();
  final _razorpay = Razorpay();

  PortfolioBloc() : super(PortfolioInitial()) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    on<LoadPortfolio>(_onLoadPortfolio);
    on<LoadTransactions>(_onLoadTransactions);
    on<CreateDeposit>(_onCreateDeposit);
    on<BuyGold>(_onBuyGold);
    on<SellGold>(_onSellGold);
    on<UpdatePortfolio>(_onUpdatePortfolio);
  }

  Future<void> _onLoadPortfolio(
    LoadPortfolio event,
    Emitter<PortfolioState> emit,
  ) async {
    try {
      emit(PortfolioLoading());
      final ApiResponse portfolio = await api.getPortfolio(event.userId);
      final ApiResponse transactions =
          await api.getTransactionHistory(event.userId);
      emit(PortfolioLoaded(portfolio.responseData, transactions.responseData));
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<PortfolioState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is PortfolioLoaded) {
        final ApiResponse transactions =
            await api.getTransactionHistory(event.userId);
        emit(
          PortfolioLoaded(
            currentState.portfolio,
            transactions.responseData,
          ),
        );
      }
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }

  Future<void> _onCreateDeposit(
    CreateDeposit event,
    Emitter<PortfolioState> emit,
  ) async {
    try {
      final ApiResponse response =
          await api.handleDeposits(event.amount, event.userId);

      final orderData = response.responseData;

      var options = {
        'key': Configure.razorpayKeyId,
        'amount': orderData['amount'],
        'name': 'Payment-App',
        'order_id': orderData['razorpayOrderId'],
        'description': 'Portfolio Deposit',
        'timeout': 300,
        'prefill': {
          'contact': '0123456789',
          'email': 'example@gmail.com',
        }
      };

      _razorpay.open(options);
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final ApiResponse res = await api.verifyPayment({
      'razorpay_payment_id': response.paymentId,
      'razorpay_order_id': response.orderId,
      'razorpay_signature': response.signature,
    });
    if (res.resultStatus == ResultStatus.success) {
      add(UpdatePortfolio(res.responseData));
    } else {
      emit(PortfolioError(res.message));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    emit(PortfolioError(response.message ?? 'Payment failed'));
  }

  Future<void> _onBuyGold(
    BuyGold event,
    Emitter<PortfolioState> emit,
  ) async {
    try {
      await api.handleBuyGold(event.amount, event.userId);
      add(UpdatePortfolio(event.userId));
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }

  Future<void> _onSellGold(
    SellGold event,
    Emitter<PortfolioState> emit,
  ) async {
    try {
      await api.handleSellGold(event.quantity, event.userId);
      add(UpdatePortfolio(event.userId));
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }

  Future<void> _onUpdatePortfolio(
    UpdatePortfolio event,
    Emitter<PortfolioState> emit,
  ) async {
    try {
      final ApiResponse portfolio = await api.getPortfolio(event.userId);
      final ApiResponse transactions =
          await api.getTransactionHistory(event.userId);
      emit(PortfolioLoaded(portfolio.responseData, transactions.responseData));
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _razorpay.clear();
    return super.close();
  }
}
