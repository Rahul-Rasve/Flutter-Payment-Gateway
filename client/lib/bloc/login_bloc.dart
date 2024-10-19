import 'package:bloc/bloc.dart';
import 'package:client/api/api_client.dart';
import 'package:client/models/api_response.dart';
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

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

//-------------------BLOC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  final ApiClient api = ApiClient();

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final ApiResponse reponse =
            await api.loginUser(event.email, event.password);
        if (reponse.resultStatus == ResultStatus.success) {
          yield LoginSuccess();
        }
        yield LoginFailure(error: reponse.message);
      } catch (e) {
        yield LoginFailure(error: e.toString());
      }
    }
  }
}
