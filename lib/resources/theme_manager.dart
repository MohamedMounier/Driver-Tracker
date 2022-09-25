
import 'package:flutter/material.dart';
import 'color_manager.dart';
import 'styles_manager.dart';

ThemeData getAppTheme(BuildContext context){
  return ThemeData(
    // colors
      primaryColor: ColorManager.sacramento,
      primaryColorLight: ColorManager.sacramento,
      primaryColorDark: ColorManager.darkPrimary,
      disabledColor: ColorManager.grey1,
      splashColor: ColorManager.lightPrimary,
      // card view theme
      cardTheme: CardTheme(
          color: ColorManager.white,
          elevation: 4,
          shadowColor: ColorManager.grey
      ),

      //App bar Theme
      appBarTheme: AppBarTheme(
          centerTitle: true,
          color: Colors.white,
          elevation:4,
          shadowColor: ColorManager.green,
          iconTheme: IconThemeData(
              color: ColorManager.sacramento
          ),
          titleTextStyle: getLargeColoredTitle(fontSize: 20.0)
      ),
      // Button Theme
      buttonTheme: ButtonThemeData(
          shape: const StadiumBorder(),
          disabledColor: ColorManager.grey1,
          buttonColor: ColorManager.sacramento,
          splashColor: ColorManager.lightPrimary
      ),
      //elevated button theme data
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle:  getRegularTextStyle(fontSize:17,color: ColorManager.white),
              primary: Colors.purple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
              )
          )
      ),
      // text theme
      textTheme: TextTheme(
          displayLarge: getLargeColoredTitle(fontSize: 22.0),
          headlineLarge: getSemiBoldTextStyle(color: ColorManager.darkGrey,fontSize: 16.0),
          headlineMedium: getRegularTextStyle(color: ColorManager.darkGrey,fontSize: 14.0),
          titleMedium: getMediumTextStyle(fontSize:14),
          bodyLarge: getBodyLargeTextStyle(color: ColorManager.white),
          bodySmall: getRegularTextStyle(color: ColorManager.grey),
          bodyMedium: getBodyMedium(),

      ),
      // input decoration theme
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(8),
          hintStyle: getRegularTextStyle(color: ColorManager.grey,fontSize:14.0),
          labelStyle: getMediumTextStyle(color: ColorManager.grey,fontSize: 14.0),
          errorStyle: getRegularTextStyle(color: ColorManager.error),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.grey,
                width: 1.5,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8))
          ),
          // focused border side
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color:  ColorManager.green,
                width: 1.5,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8))
          ),
          // error border side
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.error,
                width: 1.5,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8))
          ),
          // focused error border
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.error,
                width: 1.5,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8))
          )
      )
  );
}