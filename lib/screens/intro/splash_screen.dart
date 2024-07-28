import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../blocs/auth/splash/configuration_bloc.dart';
import '../../blocs/auth/splash/configuration_event.dart';
import '../../blocs/auth/splash/configuration_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ConfigurationBloc>().add(LoadConfiguration());

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ConfigurationBloc, ConfigurationState>(
        listener: (context, state) {
          if (state is ConfigurationLoaded) {
            // Handle the loaded configuration if needed
          } else if (state is ConfigurationError) {
            log(state.message.toString());
            // Handle the error if needed
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              SvgPicture.asset('assets/images/proggressSoft_logo.svg',width: 200,height: 100,),
              const Spacer(),
              const Text('© 2024 ProgressSoft'),
            ],
          ),
        ),
      ),
    );
  }
}
