import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_soft_task/blocs/auth/register/register_cubit.dart';
import 'package:progress_soft_task/repositories/posts_repository.dart';
import 'package:progress_soft_task/screens/auth/login_screen.dart';
import 'package:progress_soft_task/screens/auth/register_screen.dart';
import 'package:progress_soft_task/screens/intro/splash_screen.dart';
import 'package:progress_soft_task/screens/main/main_screen.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/login/login_cubit.dart';
import 'blocs/auth/splash/configuration_bloc.dart';
import 'blocs/auth/splash/configuration_event.dart';
import 'blocs/home/post_bloc.dart';
import 'blocs/profile/profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCs53Hy8BIN2ID1vxF3xc92sG7ZjNnr-M4',
        appId: 'com.example.progress_soft_task',
        projectId: 'progresssoft-3fe0c', messagingSenderId: '',
      )
  );
  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translation',
    fallbackLocale: const Locale('en'),
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final PostsRepository _postsRepository = PostsRepository(authority: 'https://jsonplaceholder.typicode.com');

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(_firebaseAuth)..add(AppStarted()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(),
        ),
        BlocProvider<RegisterCubit>(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider<PostsBloc>(
          create: (context) => PostsBloc(postsRepository: _postsRepository),
        ),
        BlocProvider<ConfigurationBloc>(
          create: (context) => ConfigurationBloc()..add(LoadConfiguration()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/main': (context) => const MainScreen(),
          '/register': (context) => const RegisterScreen(),
        },
      ),
    );
  }
}
