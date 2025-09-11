import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'observer.dart';
import 'repository/home_repo_imp.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/home_tabs/profile_tab.dart';
import 'screens/Auth/forget_password_screen.dart';
import 'screens/Auth/login_screen.dart';
import 'screens/Auth/register_screen.dart';
import 'screens/home/update_profile/update_profile.dart';
import 'screens/introduction/intro_screen.dart';
import 'screens/introduction/on_boarding_screen.dart';
import 'screens/introduction/splash_screen.dart';
import 'core/cache_helper/cache_helper.dart';
import 'core/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = MyBlocObserver();
  await SharedPreferencesHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: AppTheme.getTheme(context: context),
          debugShowCheckedModeBanner: false,
          title: 'Movies App',
          routes: _buildAppRoutes(),
          initialRoute: LoginScreen.routeName,
        );
      },
    );
  }

  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      SplashScreen.routeName: (context) => const SplashScreen(),
      onBoardingScreen.routeName: (context) => onBoardingScreen(),
      IntroScreen.routeName: (context) => IntroScreen(),
      HomeScreen.routeName: (context) => HomeScreen(),
      LoginScreen.routeName: (context) => const LoginScreen(),
      RegisterScreen.routeName: (context) => const RegisterScreen(),
      ProfileTab.routeName: (context) => const ProfileTab(),
      UpdateProfile.routeName: (context) => const UpdateProfile(),
      ForgetPasswordScreen.routeName: (context) => const ForgetPasswordScreen(),
    };
  }
}