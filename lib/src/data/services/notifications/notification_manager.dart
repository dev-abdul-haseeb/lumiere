import 'package:lumiere/src/data/services/notifications/notification_services.dart';

import '../../../domain/repositories/user_repository.dart';

class NotificationManager {
  final NotificationServices service;
  final UserRepository userRepo;

  NotificationManager({
    required this.service,
    required this.userRepo,
  });

  void init(String userId) {
    service.listenToTokenRefresh((newToken) async {
      final userResult = await userRepo.getUserDataById(userId);

      userResult.fold(
            (failure) {},
            (user) async {
          final updatedUser = user.copyWith(token: newToken);
          await userRepo.updateUser(updatedUser);
        },
      );
    });
  }
}