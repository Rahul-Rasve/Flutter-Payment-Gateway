import 'package:bloc/bloc.dart';
import 'package:client/api/api_client.dart';
import 'package:client/models/api_response.dart';
import 'package:client/models/user_model.dart';
import 'package:equatable/equatable.dart';

//-------------------EVENTS
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressed({
    required this.email,
    required this.password,
  });
}

//-------------------STATES
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserModel user;

  const LoginSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

//-------------------BLOC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  final ApiClient api = ApiClient();

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final ApiResponse response =
          await api.loginUser(event.email, event.password);
      if (response.resultStatus == ResultStatus.success) {
        emit(LoginSuccess(user: UserModel.fromJson(response.responseData)));
      } else {
        emit(LoginFailure(error: response.message));
      }
    } catch (e) {
      emit(const LoginFailure(error: "Error fetching response"));
    }
  }
}
