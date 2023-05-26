import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData dark=ThemeData(
fontFamily: 'SFProText',
  appBarTheme:const AppBarTheme(
      color: Colors.black ,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.black,

      )
  ),
  scaffoldBackgroundColor: Colors.black87,
  textTheme: TextTheme(
      bodyText1: TextStyle(fontFamily:'SFProText',color:HexColor('#CCCCCC'),fontSize: 20,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis,),
      bodyText2:TextStyle(fontFamily:'SFProText',color:HexColor('#FFFFFF'),fontSize: 20,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,)
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor:HexColor('#1F1F1F'),
    unselectedItemColor: HexColor('#CCCCCC')
  )

);