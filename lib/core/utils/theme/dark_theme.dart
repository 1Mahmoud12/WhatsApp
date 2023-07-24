import 'package:chat_first/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData dark = ThemeData(
    fontFamily: 'SFProText',
    appBarTheme: AppBarTheme(
        color: AppColors.mainColor,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: AppColors.mainColor,
        )),
    scaffoldBackgroundColor: AppColors.mainColor,
    textTheme: TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'SFProText',
          color: HexColor('#CCCCCC'),
          fontSize: 20,
          fontWeight: FontWeight.w400,
          overflow: TextOverflow.ellipsis,
        ),
        bodySmall: TextStyle(
          fontFamily: 'SFProText',
          color: HexColor('#FFFFFF'),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        )),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: HexColor('#1F1F1F'), unselectedItemColor: HexColor('#CCCCCC')));
