import 'dart:math';

import 'package:flutter/material.dart';
import 'package:raw_code/bottom_navigation.dart';
import 'package:raw_code/image_picker_widge.dart';
import 'package:raw_code/login_page.dart';
import 'package:raw_code/notifications_page.dart';
import 'package:raw_code/profile_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      home:NotificationsPage(userId: 1),
    );
  }
}
