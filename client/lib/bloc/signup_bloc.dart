import 'package:bloc/bloc.dart';
import 'package:client/api/api_client.dart';
import 'package:client/models/api_response.dart';
import 'package:equatable/equatable.dart';

//-----------EVENT
abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpButtonPressed extends SignUpEvent {
  final String name;
  final String email;
  final String password;

  const SignUpButtonPressed({
    required this.name,
    required this.email,
    required this.password,
  });
}

//-----------STATES
abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  const SignUpFailure({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

//-----------BLOC
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpButtonPressed>(_onSignUpButtonPressed);
  }

  final ApiClient api = ApiClient();

  Future<void> _onSignUpButtonPressed(
    SignUpButtonPressed event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpLoading());
    try {
      final ApiResponse response =
          await api.signUpUser(event.name, event.email, event.password);

      if (response.resultStatus == ResultStatus.success) {
        emit(SignUpSuccess());
      } else {
        emit(SignUpFailure(error: response.message));
      }
    } catch (e) {
      emit(const SignUpFailure(error: "Error fetching response"));
    }
  }
}
