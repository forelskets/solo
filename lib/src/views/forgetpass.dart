import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:http/http.dart' as http;
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/helper/sizeConfig.dart';
import 'package:vendue_vendor/src/models/forgot_model.dart';
import 'package:vendue_vendor/src/views/login.dart';

class ForgetPass extends StatefulWidget {
  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();

  ForgotModel forgotModel;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/images/back.jpg'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context)),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'FORGOT PASSWORD',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .merge(TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _forgetForm(context),
          ],
        ),
      ),
    );
  }

  Widget _forgetForm(BuildContext context) {
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
                Container(height: 50.0),
                Container(
                  // color: Colors.red,
                  child: Column(
                    children: <Widget>[
                      _emailTextfield(context),

                      Container(height: 40.0),
                      _dontHaveAnAccount(context),
                      Container(height: 40.0),
                      _loginButton(context),
                      Container(height: 40.0),
                      // _facebookButton(context),
                    ],
                  ),
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
      "assets/images/forgetImg.png",
      height: SizeConfig.blockSizeVertical * 30,
      width: SizeConfig.screenWidth,
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
          textCapitalization: TextCapitalization.none,

          controller: _emailController,
          focusNode: _emailFocus,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          // onSubmitted: (value) {
          //   FocusScope.of(context).requestFocus(_passwordFocus);
          // },
          // hintText: 'Enter Username or Email',
          // prefixIcon:
          //     Container(margin: EdgeInsets.all(10.0), child: Icon(Icons.email)),
        ),
      ],
    );
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      height: 55,
      width: MediaQuery.of(context).size.width - 170,
      child: Container(
        width: 200,
        height: 60,
        child: ProgressButton(
          color: appColorYellow,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          strokeWidth: 2,
          child: Text(
            "Submit",
            style: TextStyle(
              color: appColorWhite,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          onPressed: (AnimationController controller) {
            _submit(controller);
          },
        ),
      ),
    );
  }

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
        recognizer: new TapGestureRecognizer()
          ..onTap = () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Login(),
                ),
              ),
        text: "Remember password? ",
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
                      builder: (context) => Login(),
                    ),
                  ),
            text: 'Sign in',
            style: TextStyle(
                fontFamily: "harabaraBold",
                fontWeight: FontWeight.w100,
                color: appColorYellow),
          ),
        ],
      ),
    );
  }

  _submit(AnimationController controller) async {
    // setState(() {
    //   isLoading = true;
    // });

    if (_emailController.text.isNotEmpty) {
      controller.forward();

      var uri = Uri.parse('${baseUrl()}/vendor_forgot_pass');
      var request = new http.MultipartRequest("POST", uri);
      Map<String, String> headers = {
        "Accept": "application/json",
      };
      request.headers.addAll(headers);
      // request.fields.addAll({'user_id': userID});
      request.fields['email'] = _emailController.text;
      var response = await request.send();
      print(response.statusCode);
      String responseData =
          await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responseData);
      forgotModel = ForgotModel.fromJson(userData);
      print("+++++++++");
      print(responseData);
      print("+++++++++");

      if (forgotModel.status == 1) {
        _showToast();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
          (Route<dynamic> route) => false,
        );
      }

      controller.reverse();
    } else {
      _showSnackBar(context, "Please enter email");
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

  _showToast() {
    return Fluttertoast.showToast(
        msg: "New password has been sent to your email.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 15.0);
  }
}
