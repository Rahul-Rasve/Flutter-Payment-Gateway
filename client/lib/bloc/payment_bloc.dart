import "package:client/api/api_client.dart";
import "package:client/config/config.dart";
import "package:client/models/api_response.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:razorpay_flutter/razorpay_flutter.dart";

//-----------EVENTS
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class CreatePaymentOrder extends PaymentEvent {
  final double amount;
  final String userId;

  const CreatePaymentOrder({required this.amount, required this.userId});
}

class VerifyPayment extends PaymentEvent {
  final Map<String, dynamic> paymentData;

  const VerifyPayment({required this.paymentData});
}

class PaymentErrorEvent extends PaymentEvent {
  final String error;
  const PaymentErrorEvent({required this.error});
}

//-----------STATE
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentFailure extends PaymentState {
  final String error;

  const PaymentFailure({required this.error});
}

//-----------BLOC
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final _razorpay = Razorpay();
  final ApiClient api = ApiClient();

  PaymentBloc() : super(PaymentInitial()) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    on<CreatePaymentOrder>(_createPaymentOrder);
    on<VerifyPayment>(_verifyPayment);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    add(
      VerifyPayment(
        paymentData: {
          'razorpay_signature': response.signature,
          'razorpay_payment_id': response.paymentId,
          'razorpay_order_id': response.orderId,
        },
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    add(
      PaymentErrorEvent(error: response.message ?? 'Payment failed'),
    );
  }

  @override
  Future<void> close() {
    _razorpay.clear();
    return super.close();
  }

  Future<void> _createPaymentOrder(event, emit) async {
    emit(PaymentLoading());
    try {
      final ApiResponse response = await api.createPayementOrder(
        event.amount,
        event.userId,
      );

      if (response.resultStatus == ResultStatus.success) {
        final options = {
          'key': Configure.razorpayKeyId,
          'amount': response.responseData['amount'],
          'name': 'Payment-App',
          'order_id': response.responseData['paymentId'],
          'prefill': {
            'contact': '0123456789',
            'email': 'example@gmail.com',
          },
        };

        _razorpay.open(options);
      } else {
        emit(PaymentFailure(error: response.message));
      }
    } catch (e) {
      emit(
        const PaymentFailure(error: "Failed to make the payment!"),
      );
    }
  }

  Future<void> _verifyPayment(event, emit) async {
    emit(PaymentLoading());
    try {
      final ApiResponse response = await api.verifyPayment(event.paymentData);
      if (response.resultStatus == ResultStatus.success) {
        emit(PaymentSuccess());
      } else {
        emit(PaymentFailure(error: response.message));
      }
    } catch (e) {
      emit(const PaymentFailure(error: "Failed to verify payment!"));
    }
  }
}
