
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Screen/AdminSide/Admin.dart';
import '../Screen/ForgotPassword/ForgotPassword.dart';
import '../Screen/HomePage/HomePage.dart';
import '../Screen/Login/LoginScreen.dart';
import '../Screen/SignUp/SignUp.dart';
import '../Screen/Splash.dart';



part 'app_routes.dart';

class AppPages {

  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () =>  SplashScreen(),
    ),
    GetPage(
      name: _Paths.ForgotPassword,
      page: () =>  ForgotPassword(),
    ),
    // GetPage(
    //   name: _Paths.PhoneAuthen,
    //   page: () =>  PhoneAuthentication(),
    // ),
    GetPage(
      name: _Paths.Admin,
      page: () =>  Admin(),
    ),
     GetPage(
      name: _Paths.SIGNUP,
      page: () =>  SignUpScreen(),
    ),
     GetPage(
      name: _Paths.LOGIN,
      page: () =>  SignIn(),
    ),
    GetPage(
      name: _Paths.Homepages,
      page: () =>  HomePage(),
    ),

  ];
}
