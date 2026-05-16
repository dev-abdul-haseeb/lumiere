import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lumiere/src/core/enum/enum.dart';
import 'package:lumiere/src/core/theme/theme.dart';
import 'package:lumiere/src/data/datasources/application_remote_datasource.dart';
import 'package:lumiere/src/data/datasources/auth_remote_datasource.dart';
import 'package:lumiere/src/data/datasources/product_remote_datasource.dart';
import 'package:lumiere/src/data/datasources/user_remote_datasource.dart';
import 'package:lumiere/src/data/repositories/application_repository_impl.dart';
import 'package:lumiere/src/data/repositories/auth_repository_impl.dart';
import 'package:lumiere/src/data/repositories/notification_repository_impl.dart';
import 'package:lumiere/src/data/repositories/product_repository_impl.dart';
import 'package:lumiere/src/data/repositories/user_repository_impl.dart';
import 'package:lumiere/src/data/services/notifications/notification_services.dart';
import 'package:lumiere/src/presentation/blocs/application/application_bloc.dart';
import 'package:lumiere/src/presentation/blocs/auth/auth_bloc.dart';
import 'package:lumiere/src/presentation/blocs/product/product_bloc.dart';
import 'package:lumiere/src/presentation/routers/views.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    await GoogleSignIn.instance.initialize();
  } else if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    const clientId = String.fromEnvironment('WEB_CLIENT_ID');
    await GoogleSignIn.instance.initialize(
      serverClientId: clientId,
    );
  }

  const supabase_url = String.fromEnvironment('SUPABASE_URL');
  const supabase_anon_key = String.fromEnvironment('SUPABASE_ANON_KEY');
  await Supabase.initialize(
    url: supabase_url,
    anonKey: supabase_anon_key,
  );
  usePathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(
                authRepo: AuthRepositoryImpl(authRemoteDatasource: AuthRemoteDatasource()),
                userRepo: UserRepositoryImpl(userRemoteDatasource: UserRemoteDatasource()),
                notificationRepo: NotificationRepositoryImpl(NotificationServices()),
              ),
            ),
        BlocProvider<ApplicationBloc>(
          create: (_) => ApplicationBloc(
            applicationRepository: ApplicationRepositoryImpl(),
          ),  // fetch data right away on app start
        ),

        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc(
              repository: ProductRepositoryImpl(
                  productRemoteDatasource: ProductRemoteDatasource(
                      firestore: FirebaseFirestore.instance,
                      supabase: Supabase.instance.client
                  )
              )
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LUMIÈRE',
        home: BlocBuilder<ApplicationBloc, ApplicationState>(
          builder: (context, state) {
            if (state is ApplicationInitial || state is ApplicationLoading) {
              return Scaffold(
                backgroundColor: AppColors.get(appColors.background),
                body: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.get(appColors.highlight),
                  ),
                ),
              );
            }
            return const SplashScreen();
          },
        ),
      ),

    );
  }
}