import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//-------------EVENTS
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeEvent {
  final String name;
  final String portfolio;

  const HomeLoading({required this.name, required this.portfolio});
}

//-------------STATES
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {}

class HomeLoadingFailure extends HomeState {
  final String error;

  const HomeLoadingFailure({required this.error});
}

//-------------BLOC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoading>(_onHomeLoading);
  }

  Future<void> _onHomeLoading(
    HomeLoading event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoaded());
  }
}
