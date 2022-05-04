import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/sharedpref/preferencesKey.dart';
import 'package:vendue_vendor/src/views/login.dart';
import 'package:vendue_vendor/src/views/phone/phone_auth.dart';
import 'package:vendue_vendor/src/views/tabbar.dart';

class App extends StatelessWidget {
  final SharedPreferences prefs;
  App(this.prefs);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setnotification();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => PhoneAuthDataProvider(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.grey,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Product Sans',
          ),
          debugShowCheckedModeBanner: false,
          home: _handleCurrentScreen(prefs),
        ));
  }

  setnotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Widget _handleCurrentScreen(SharedPreferences prefs) {
    String data = prefs.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);
    preferences = prefs;
    if (data == null) {
      return Login();
    } else {
      return TabbarScreen(currentIndex: 0);
    }
  }
}
