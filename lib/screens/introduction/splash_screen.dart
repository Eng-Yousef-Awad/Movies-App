import 'package:flutter/material.dart';
import 'package:movies_app/screens/Auth/login_screen.dart';
import '../../core/cache_helper/cache_helper.dart';
import 'intro_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds:1500),
      () {
        Navigator.pushReplacementNamed(context,SharedPreferencesHelper.getOnBoardingSeen() ? LoginScreen.routeName : IntroScreen.routeName);
      },
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash.png',
            ),
          ],
        ),
      ),
    );
  }
}
