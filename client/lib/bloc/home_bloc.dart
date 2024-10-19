import 'package:client/api/api_client.dart';
import 'package:client/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//-------------EVENTS
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeEvent {
  final UserModel user;

  const HomeLoading({required this.user});
}

//-------------STATES
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final UserModel user;

  const HomeLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class HomeLoadingFailure extends HomeState {
  final String error;

  const HomeLoadingFailure({required this.error});
}

//-------------BLOC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoading>(_onHomeLoading);
  }

  final ApiClient api = ApiClient();

  Future<void> _onHomeLoading(
    HomeLoading event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoaded(user: event.user));
    } catch (e) {
      emit(const HomeLoadingFailure(error: "Error fetching response"));
    }
  }
}
