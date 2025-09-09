import 'package:flutter/material.dart';

var theme = ThemeData(
  iconTheme: IconThemeData( //아이콘 전채 색상
      color: Colors.black45),

  appBarTheme: AppBarTheme( //앱 상단 바 디자인
    color: Colors.white,
    elevation: 1,
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 30),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(//앱 하단 바 디자인
    elevation: 1,
    backgroundColor: Colors.white70,
    selectedIconTheme: IconThemeData(color: Colors.black),
  ),

  textTheme: TextTheme( //앱 텍스트 디자인
    bodyMedium:TextStyle(color: Colors.black54),
  ),
);