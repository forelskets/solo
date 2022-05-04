import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/helper/sizeConfig.dart';
import 'package:vendue_vendor/src/models/signin_model.dart';
import 'package:vendue_vendor/src/sharedpref/preferencesKey.dart';
import 'package:vendue_vendor/src/views/forgetpass.dart';
import 'package:vendue_vendor/src/views/signup.dart';

import 'package:vendue_vendor/src/views/tabbar.dart';
import 'package:progress_indicator_button/progress_button.dart';

import 'google signin/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _conpass = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _fcmtoken = "";
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  SigninModel signinModel;

  double _height, _width;

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  _getToken() {
    firebaseMessaging.getToken().then((token) {
      setState(() {
        _fcmtoken = token;
      });
      print(_fcmtoken);
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    SizeConfig().init(context);
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/images/back.jpg'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          // leading: new IconButton(
          //   icon: Icon(
          //     Icons.arrow_back_ios,
          //     color: Colors.black,
          //   ),
          //   onPressed: () {
          //     Navigator.pop(context);
          //     // Navigator.push(
          //     //   context,
          //     //   CupertinoPageRoute(
          //     //     builder: (context) => WelcomeScreen(),
          //     //   ),
          //     // );
          //   },
          // ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _loginForm(context),
          ],
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _appIcon(),
              Container(height: 30.0),
              Container(
                // color: Colors.red,
                child: Column(
                  children: <Widget>[
                    _emailTextfield(context),
                    Container(height: 10.0),
                    _passwordTextfield(context),
                    Container(height: 10.0),
                    _forgotPassword(),
                    Container(height: 40.0),
                    _loginButton(context),
                    // Container(height: 40.0),
                    // _facebookButton(context),
                  ],
                ),
              ),
              Container(height: 10.0),
              _dontHaveAnAccount(context),
              Container(height: 50.0),
              _googleButton(context),
              // Container(height: 20.0),
              // _mobileButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appIcon() {
    return Image.asset(
      "assets/images/eshield.png",
      height: 100,
    );
  }

  Widget _emailTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Email ID',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomtextField(
          controller: _emailController,
          focusNode: _emailFocus,

          textCapitalization: TextCapitalization.none,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(_passwordFocus);
          },
          // hintText: 'Enter Username or Email',
          // prefixIcon:
          //     Container(margin: EdgeInsets.all(10.0), child: Icon(Icons.email)),
        ),
      ],
    );
  }

  Widget _passwordTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Password',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomtextField(
          controller: _passwordController,
          maxLines: 1,
          focusNode: _passwordFocus,
          textCapitalization: TextCapitalization.none,

          onSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          obscureText: _conpass,
          suffixIcon: IconButton(
            highlightColor: Colors.transparent,
            hoverColor: Colors.black,
            onPressed: () {
              setState(() {
                _conpass = !_conpass;
              });
            },
            color: Theme.of(context).focusColor,
            icon: Icon(_conpass
                ? CupertinoIcons.eye_slash_fill
                : CupertinoIcons.eye_fill),
          ),
          // hintText: 'Enter Password',
          // prefixIcon: Icon(Icons.lock),
        ),
      ],
    );
  }

  Widget _forgotPassword() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text.rich(
          TextSpan(
            recognizer: new TapGestureRecognizer()
              ..onTap = () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPass()),
                  ),
            text: 'Forgot Password?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width - 60,
      child: Container(
        width: 200,
        height: 60,
        child: ProgressButton(
          color: appColorYellow,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          strokeWidth: 2,
          child: Text(
            "Sign In",
            style: TextStyle(
              color: appColorWhite,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          onPressed: (AnimationController controller) {
            _apicall(controller);
          },
        ),
      ),
    );
  }

  Widget _googleButton(BuildContext context) {
    return SizedBox(
      height: _height * 0.55 / 10,
      width: _width * 8.3 / 10,
      child: Container(
        child: ProgressButton(
          color: Colors.grey.shade50,
          progressIndicatorColor: appColorGreen,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          strokeWidth: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/images/google.png",
                height: 25,
              ),
              Text(
                "Login in with Google",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: fontFamily),
              ),
            ],
          ),
          onPressed: (AnimationController controller) {
            setState(() {
              controller.forward();
            });

            signInWithGoogle(context, _fcmtoken).whenComplete(() {
              setState(() {
                controller.reverse();
              });
            });
          },
        ),
      ),
    );
  }

  // Widget _mobileButton(BuildContext context) {
  //   return SizedBox(
  //     height: _height * 0.55 / 10,
  //     width: _width * 8.3 / 10,
  //     child: Container(
  //       child: ProgressButton(
  //         color: Colors.grey.shade50,
  //         progressIndicatorColor: appColorGreen,
  //         borderRadius: BorderRadius.all(Radius.circular(8)),
  //         strokeWidth: 3,
  //         child: Text(
  //           "Login with Mobile Number",
  //           style: TextStyle(
  //               color: Colors.black,
  //               fontSize: 16,
  //               fontWeight: FontWeight.w600,
  //               fontFamily: fontFamily),
  //         ),
  //         onPressed: (AnimationController controller) {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => PhoneLogin()),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget _facebookButton(BuildContext context) {
  //   return SizedBox(
  //     height: 55,
  //     width: MediaQuery.of(context).size.width - 170,
  //     child: RaisedButton(
  //       color: Color(0XFF3b5998),
  //       child: Row(
  //         children: <Widget>[
  //           Text(
  //             'Play this song',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ],
  //       ),
  //       onPressed: () {},
  //       shape: RoundedRectangleBorder(
  //         borderRadius: new BorderRadius.circular(35.0),
  //         //  side: BorderSide(color: Colors.red)
  //       ),
  //     ),
  //   );
  // }

  Widget _dontHaveAnAccount(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Don't have an account? ",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        children: <TextSpan>[
          TextSpan(
            recognizer: new TapGestureRecognizer()
              ..onTap = () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => Registration(),
                    ),
                  ),
            text: 'Sign Up',
            style: TextStyle(
                fontFamily: "harabaraBold",
                fontWeight: FontWeight.w100,
                color: appColorYellow),
          ),
        ],
      ),
    );
  }

  _apicall(AnimationController controller) async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      controller.forward();
      var uri = Uri.parse('${baseUrl()}/vendor_login');
      var request = new http.MultipartRequest("POST", uri);
      Map<String, String> headers = {
        "Accept": "application/json",
      };
      request.headers.addAll(headers);
      request.fields['email'] = _emailController.text;
      request.fields['password'] = _passwordController.text;
      request.fields['device_token'] = _fcmtoken;

      var response = await request.send();
      print(response.statusCode);
      String responseData =
          await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responseData);

      signinModel = SigninModel.fromJson(userData);

      if (signinModel.responseCode == "1") {
        String userResponseStr = json.encode(userData);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(
            SharedPreferencesKey.LOGGED_IN_USERRDATA, userResponseStr);

        controller.reverse();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => TabbarScreen(currentIndex: 0),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        controller.reverse();
        _showSnackBar(context, "Please enter valid login details");
      }

      print(responseData);

      controller.reverse();
    } else {
      _showSnackBar(context, "Please enter email / password");
    }
  }

  void _showSnackBar(BuildContext context, String text) {
// ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        // backgroundColor: Colors.grey,
        content: Text(text),
        duration: const Duration(seconds: 60),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Close',
          onPressed: () {},
        ),
      ),
    );
  }
}
