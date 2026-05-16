part of 'application_bloc.dart';

abstract class ApplicationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApplicationInitial extends ApplicationState {}

class ApplicationLoading extends ApplicationState {}

class ApplicationLoaded extends ApplicationState {
  final Application application;

  ApplicationLoaded(this.application);

  @override
  List<Object?> get props => [application];
}

class ApplicationUpdated extends ApplicationState {
  final Application application;

  ApplicationUpdated(this.application);

  @override
  List<Object?> get props => [application];
}

class ApplicationError extends ApplicationState {
  final String message;

  ApplicationError(this.message);

  @override
  List<Object?> get props => [message];
}