part of 'application_bloc.dart';

abstract class ApplicationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetApplicationData extends ApplicationEvent {}

class UpdateApplicationData extends ApplicationEvent {
  final Application application;

  UpdateApplicationData(this.application);

  @override
  List<Object?> get props => [application];
}