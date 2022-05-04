import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vendue_vendor/app.dart';
import 'package:vendue_vendor/src/global/constant.dart';
import 'package:vendue_vendor/src/views/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SharedPreferences.getInstance().then(
    (prefs) async {
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "EShield Vendor",
          theme: new ThemeData(
              primaryColor: Colors.black,
              primaryColorDark: Colors.black,
              colorScheme:
                  ColorScheme.fromSwatch().copyWith(secondary: Colors.black)),
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            App_Screen: (BuildContext context) => App(prefs),
          },
        ),
      );
    },
  );
}
