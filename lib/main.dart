import 'package:fccm/model/mapss.dart';
import 'package:fccm/model/currentlocation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'notifications_bloc.dart';
import 'introduction_animation/introduction_animation_screen.dart';
import 'package:fccm/drivers/continue.dart';
import 'notific.dart';
import 'package:fccm/not/nott.dart';
import 'package:fccm/not/message.dart';
import 'notific.dart';
import 'package:fccm/login_signup/forget.dart';
import 'nn.dart';
import 'pages/map/map_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.teal,
    ),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/notification-screen': (context) => NnotificationScreen(),
      '/NotificationScreenn': (context) => NotificationScreenn(),
      '/CurrentLocationScreen': (context) => CurrentLocationScreen(),
      '/mapss': (context) => mapss(),
      '/NotificationSender': (context) => NotificationSender(),
      '/continuePage': (context) => continuePage(key: UniqueKey(), user: null),
      // '/NotificationScreen': (context) => NotificationScreen(),
      '/ChatScreen': (context) => ChatScreen(),
      '/ForgetScreen': (context) => ForgetScreen(),
      '/HomeScreen': (context) => HomeScreen(),
      '/MapView': (context) => MapView(),
    },
    home: const IntroductionAnimationScreen(),
  ));
}
