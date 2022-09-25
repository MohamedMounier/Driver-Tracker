

import 'package:flutter/material.dart';
import 'package:track_it_app/presentation/auth_screens/login_screen.dart';

class Routes {
  static const String spalshRoute='/';
  static const String audioScreen='/audioScreen';
  static const String readingScreen='/readingScreen';
  static const String forgotPassRoute='/forgotPass';
  static const String mainRoute='/main';
  static const String homeRoute='/home';
  static const String loginRoute='/login';
  static const String userInfoRoute='/userInfoRoute';
  static const String storeDetailsRoute='/storeDetails';
  static const String onBoardingRoute='/onBoarding';
  static const String packsRoute='/packsRoute';
  static const String chaptersPage='/chaptersPage';
  static const String allAhadeethPage='/allAhadeethPage';
  static const String favouriteAhadeethPage='/favouriteAhadeethPage';
  static const String azkarWrittenRoute='/azkarWrittenRoute';
  static const String numberCheckerRoute='/numberCheckerRoute';
  static const String layoutRoute='/layoutRoute';
  static const String internationalRoute='/internationalRoute';
  static const String deviceIDCheckRoute='/deviceIDCheckRoute';
  static Route? generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=>LoginScreen());
    }
  }

}

