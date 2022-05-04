import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/views/google%20signin/google_sign_in.dart';
import 'package:vendue_vendor/src/views/login.dart';
import 'package:vendue_vendor/src/views/phone/phoneLogin.dart';
import 'package:vendue_vendor/src/views/signup.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _height, _width;
  bool isLoading = false;
  String _fcmtoken = "";
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _body(context),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _appIcon(),
                Container(height: _height * 0.50 / 10),
                Column(
                  children: <Widget>[
                    _loginButton1(context),
                    Container(height: _height * 0.030),
                    _signupButton1(context),
                    // Container(height: _height * 1 / 10),
                    // _loginButton(context),
                    Container(height: _height * 0.030),
                    _googleButton(context),
                    Container(height: _height * 0.030),
                    _mobileButton(context),
                    Container(height: _height * 1 / 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appIcon() {
    return Image.asset(
      "assets/images/nlytical_logo.png",
      height: 130,
    );
  }

  Widget _loginButton1(BuildContext context) {
    return SizedBox(
      height: _height * 0.55 / 10,
      width: _width * 8 / 10,
      child: CustomButtom(
        title: 'Sign in',
        color: appColorYellow,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: appColorBlack,
            fontFamily: fontFamily),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Login(),
            ),
          );
        },
      ),
    );
  }

  Widget _signupButton1(BuildContext context) {
    return SizedBox(
      height: _height * 0.55 / 10,
      width: _width * 8 / 10,
      child: CustomButtom(
        title: 'Sign up',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: appColorBlack,
            fontFamily: fontFamily),
        color: appColorYellow,
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Registration(),
            ),
          );
        },
      ),
    );
  }

/* FB
  Widget _loginButton(BuildContext context) {
    return SizedBox(
      height: _height * 0.55 / 10,
      width: _width * 8 / 10,
      child: Container(
        child: ProgressButton(
          color: appColorYellow,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          strokeWidth: 2,
          child: Text(
            "Sign in with Facebook",
            style: TextStyle(
                color: appColorBlack,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: fontFamily),
          ),
          onPressed: (AnimationController controller) {
            setState(() {
              controller.forward();
            });

            _login().whenComplete(() {
              setState(() {
                controller.reverse();
              });
            });
          },
        ),
      ),
    );
  }

 FB */

  Widget _googleButton(BuildContext context) {
    return SizedBox(
      height: _height * 0.55 / 10,
      width: _width * 8 / 10,
      child: Container(
        child: ProgressButton(
          color: appColorYellow,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          strokeWidth: 2,
          child: Text(
            "Sign in with Google",
            style: TextStyle(
                color: appColorBlack,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: fontFamily),
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

  Widget _mobileButton(BuildContext context) {
    return SizedBox(
      height: _height * 0.55 / 10,
      width: _width * 8 / 10,
      child: Container(
        child: ProgressButton(
          color: appColorYellow,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          strokeWidth: 2,
          child: Text(
            "Sign in with Mobile Number",
            style: TextStyle(
                color: appColorBlack,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                fontFamily: fontFamily),
          ),
          onPressed: (AnimationController controller) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PhoneLogin()),
            );
          },
        ),
      ),
    );
  }
/* face book login embedding fail issue 

  static final FacebookLogin facebookSignIn = new FacebookLogin();
  SocialModel socialModel;
  Map userProfile;
  String fbuserID;

  Future<Null> _login() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        final graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${accessToken.token}'));

        final profile = JSON.jsonDecode(graphResponse.body);
        print(">>>>>>>>");
        print(profile);
        setState(() {
          userProfile = profile;
          fbuserID = accessToken.userId;
        });

        if (accessToken.token != null) {
          _userDataPost();
          print(">>>>>>>><<<<<");
          print(accessToken.userId);
        }

        // print(_message.toString());
        // _showMessage('''
        //  Logged in!

        //  Token: ${accessToken.token}
        //  User id: ${accessToken.userId}
        //  Expires: ${accessToken.expires}
        //  Permissions: ${accessToken.permissions}
        //  Declined permissions: ${accessToken.declinedPermissions}
        //  ''');

        break;
      case FacebookLoginStatus.cancelledByUser:
        Flushbar(
          title: "cancelled",
          message: "Login cancelled",
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ),
        )..show(context);
        // _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        Flushbar(
          title: "Something went wrong",
          message: 'Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}',
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ),
        )..show(context);
        // _showMessage('Something went wrong with the login process.\n'
        //     'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  _userDataPost() async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}/vendor_social_login');
    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({
      'username': userProfile["name"],
      'facebook_id': fbuserID.toString(),
      'email': userProfile["email"] != null ? userProfile["email"] : "",
      'image_url': userProfile["picture"]["data"]["url"] != null
          ? userProfile["picture"]["data"]["url"]
          : "",
      'login_type': 'facebook',
      'device_token': _fcmtoken
    });
    // request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    socialModel = SocialModel.fromJson(userData);

    if (socialModel.responseCode == "1") {
      String userResponseStr = json.encode(userData);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(
          SharedPreferencesKey.LOGGED_IN_USERRDATA, userResponseStr);

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => TabbarScreen(currentIndex: 0),
        ),
        (Route<dynamic> route) => false,
      );
      // _refreshCart();
    } else {
      setState(() {
        isLoading = false;
      });
      Flushbar(
        title: "Failure",
        message: "Facebook login fail!",
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
      )..show(context);
    }

    print(responseData);

    setState(() {
      isLoading = false;
    });
  }

  */
}
