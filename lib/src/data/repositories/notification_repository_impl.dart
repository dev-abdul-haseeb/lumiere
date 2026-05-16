import '../../domain/repositories/notification_repository.dart';
import '../services/notifications/notification_services.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationServices _service;

  NotificationRepositoryImpl(this._service);

  @override
  Future<String> getDeviceToken() {
    return _service.getDeviceToken();
  }
}