import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/src/data/services/notifications/notification_manager.dart';
import 'package:lumiere/src/presentation/pages/authentication/data_entry_screen.dart';

import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/datasources/user_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../data/repositories/notification_repository_impl.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../data/services/notifications/notification_services.dart';
import '../../blocs/auth/auth_bloc.dart';

import 'package:lumiere/src/presentation/routers/views.dart';

class AuthWrapperScreen extends StatefulWidget {
  const AuthWrapperScreen({super.key});

  @override
  State<AuthWrapperScreen> createState() => _AuthWrapperScreenState();
}

class _AuthWrapperScreenState extends State<AuthWrapperScreen> {

  late final AuthRepositoryImpl authRepo;
  late final UserRepositoryImpl userRepo;
  late final NotificationRepositoryImpl notificationRepo;
  late final NotificationManager manager;

  @override
  void initState() {
    super.initState();
    userRepo = UserRepositoryImpl(userRemoteDatasource: UserRemoteDatasource());
    manager  = NotificationManager(
      service:  NotificationServices(),
      userRepo: userRepo,
    );
    context.read<AuthBloc>().add(IsLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          manager.init(state.user.user_id); // ← fires once on state change
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {

            if(state.user.first_name == '') {
              return DataEntryScreen(user: state.user);
            }
            else {
              String name = state.user.first_name + ' ' + state.user.last_name;
              return state.user.is_admin
                ? AdminHomeScreen(admin_name: name)
                : const BuyerHomeScreen();
            }
          }
          return const LoginScreen();
        },
      ),
    );
  }
}