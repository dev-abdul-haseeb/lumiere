import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lumiere/src/domain/entities/application.dart';
import 'package:lumiere/src/domain/repositories/application_repository.dart';

part 'application_event.dart';
part 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final ApplicationRepository _applicationRepository;

  ApplicationBloc({required ApplicationRepository applicationRepository})
      : _applicationRepository = applicationRepository,
        super(ApplicationInitial()) {
    on<GetApplicationData>(_onGetApplicationData);
    on<UpdateApplicationData>(_onUpdateApplicationData);

    add(GetApplicationData());
  }

  Future<void> _onGetApplicationData(GetApplicationData event, Emitter<ApplicationState> emit,) async {
    emit(ApplicationLoading());
    final result = await _applicationRepository.getApplicationData();
    result.fold(
          (failure) => emit(ApplicationError(failure.message)),
          (application) => emit(ApplicationLoaded(application)),
    );
  }

  Future<void> _onUpdateApplicationData(UpdateApplicationData event, Emitter<ApplicationState> emit) async {
    emit(ApplicationLoading());
    final result = await _applicationRepository.updateApplicationData(event.application);
    result.fold(
          (failure) => emit(ApplicationError(failure.message)),
          (application) => emit(ApplicationUpdated(application)),
    );
  }
}