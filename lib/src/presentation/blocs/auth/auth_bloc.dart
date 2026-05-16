import 'package:bloc/bloc.dart';
import 'package:lumiere/src/domain/repositories/notification_repository.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/user_repository.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;
  final UserRepository userRepo;
  final NotificationRepository notificationRepo;

  AuthBloc({
    required this.authRepo,
    required this.userRepo,
    required this.notificationRepo,
  }) : super(AuthInitial()) {

    on<IsLoggedIn> (_isLoggedIn);
    on<SignUpWithPasswordRequested>(_onSignUpWithPassword);
    on<SignInWithPasswordRequested>(_onSignInWithPassword);
    on<SignInWithGmailRequested>(_onSignInWithGmail);
    on<UpdateUserDataRequested>(_updateUserDataRequested);
    on<ForgetPasswordRequested>(_forgetPasswordRequested);
    on<AuthLogOut>(_logOutUser);
  }

  Future<void> _isLoggedIn(IsLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await authRepo.getCurrentUser();
    await result.fold(
      (failure) async {
        emit(AuthUnAuthenticated());
      },
      (firebaseUser) async {
        final userResult =
        await userRepo.getUserDataById(firebaseUser.uid);

        await userResult.fold(
          (failure) async {
            emit(AuthFailure(failure.message));
          },
          (user) async {
            emit(AuthAuthenticated(user));
          },
        );
      },
    );
  }

  Future<void> _onSignUpWithPassword(SignUpWithPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final authResult = await authRepo.signUpWithEmailAndPassword(event.email, event.password);
    await authResult.fold(
      (failure) async {
        emit(AuthFailure(failure.message));
      },
      (firebaseUser) async {
        String token = "";
        try {
          token = await notificationRepo.getDeviceToken();
        } catch (_) {
          token = "";
        }
        final user = User(
          user_id: firebaseUser.uid,
          email: firebaseUser.email ?? event.email,
          first_name: '',
          last_name: '',
          phone_number: '',
          token: token,
          is_admin: false,
        );
        final userResult = await userRepo.createUserInDb(user);
        await userResult.fold(
          (failure) async {
            emit(AuthFailure(failure.message));
          },
          (user) async {
            emit(AuthAuthenticated(user));
          },
        );
      },
    );
  }
  
  Future<void> _onSignInWithPassword(SignInWithPasswordRequested event, Emitter<AuthState> emit) async {

    emit(AuthLoading());

    final authResult = await authRepo.signInWithEmailAndPassword(
      event.email,
      event.password,
    );
    await authResult.fold(
      (failure) async {
        emit(AuthFailure(failure.message));
      },
      (firebaseUser) async {
        final userResult = await userRepo.getUserDataById(firebaseUser.uid);
        await userResult.fold(
          (failure) async {
            emit(AuthFailure(failure.message));
          },
          (user) async {
            // Update device token on login
            String token = "";
            try {
              token = await notificationRepo.getDeviceToken();
            } catch (_) {}

            final updatedUser = user.copyWith(token: token);
            await userRepo.updateUser(updatedUser);

            emit(AuthAuthenticated(updatedUser));
          },
        );
      },
    );
  }

  Future<void> _onSignInWithGmail(SignInWithGmailRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final authResult = await authRepo.signInWithGoogle();
    await authResult.fold(
          (failure) async {
        emit(AuthFailure(failure.message));
      },
          (firebaseUser) async {
        // Get device token
        String token = "";
        try {
          token = await notificationRepo.getDeviceToken();
        } catch (_) {}

        final userResult = await userRepo.getUserDataById(firebaseUser.uid);
        await userResult.fold(
              (failure) async {
            // User doesn't exist in Firestore → new Google user → create them
            final newUser = User(
              user_id: firebaseUser.uid,
              email: firebaseUser.email ?? '',
              first_name: '',
              last_name: '',
              phone_number: '',
              token: token,
              is_admin: false,
            );

            final createResult = await userRepo.createUserInDb(newUser);
            await createResult.fold(
                  (failure) async => emit(AuthFailure(failure.message)),
                  (user) async => emit(AuthAuthenticated(user)),
            );
          },
              (user) async {
            // Existing user → just update token
            final updatedUser = user.copyWith(token: token);
            await userRepo.updateUser(updatedUser);
            emit(AuthAuthenticated(updatedUser));
          },
        );
      },
    );
  }

  Future<void> _updateUserDataRequested(UpdateUserDataRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print('Id:' + event.user.user_id);
    final first_name = event.first_name;
    final last_name = event.last_name;
    final phone_number = event.phone_number;
    final updatedUser = event.user.copyWith(first_name: first_name, last_name: last_name, phone_number: phone_number);
    await userRepo.updateUser(updatedUser);
    emit(AuthAuthenticated(updatedUser));
  }

  Future<void> _forgetPasswordRequested(ForgetPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    authRepo.sendPasswordResetEmail(event.email);
    add(AuthLogOut());

  }

  Future<void> _logOutUser (AuthLogOut event, Emitter<AuthState> emit) async {
    await authRepo.signOut();
    emit(AuthUnAuthenticated());
  }
}