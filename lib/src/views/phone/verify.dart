import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/views/phone/phone_auth.dart';

class PhoneAuthVerify extends StatefulWidget {
  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState();
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  BuildContext scaffoldContext;
  String code = "";
  int endTime;
  bool isLoading = false;

  @override
  void initState() {
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 120;
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);

    phoneAuthDataProvider.setMethods(
      onStarted: onStarted,
      onError: onError,
      onFailed: onFailed,
      onVerified: onVerified,
      onCodeResent: onCodeResent,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeOut,
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(automaticallyImplyLeading: true,elevation: 0,backgroundColor: Colors.white,),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _verifyForm(context),
          isLoading == true ? Center(child: loader(context)) : Container()
        ],
      ),
    );
  }

  Widget _verifyForm(BuildContext context) {
    return Center(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              applogo(),
              Container(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Verify phone number",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          "Enter 6 digits verification code sent to your number",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 100, right: 100),
                child: TextField(
                  textAlign: TextAlign.center,
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    code = value;
                  },
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              Container(height: 50.0),
              _submitButton(context),
              Container(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: SizedBox(
        height: 55,
        width: double.infinity,
        child: CustomButtom(
            title: 'SUBMIT',
            color: appColorYellow,
            style: TextStyle(color: appColorWhite, fontWeight: FontWeight.bold),
            onPressed: signIn),
      ),
    );
  }

  Widget applogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/eshield.png',
          height: 130,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: '',
          onPressed: () {},
        )));
  }

  signIn() {
    closeKeyboard();
    setState(() {
      isLoading = true;
    });
    if (code.length != 6) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar(context, "Invalid OTP");
    }
    Provider.of<PhoneAuthDataProvider>(context, listen: false)
        .verifyOTPAndLogin(smsCode: code, context: context);
  }

  onStarted() {
    _showSnackBar(context, "PhoneAuth started");
  }

  onCodeSent() {
    _showSnackBar(context, "OPT sent");
  }

  onCodeResent() {
    _showSnackBar(context, "OPT resent");
  }

  onVerified() async {
    setState(() {
      isLoading = false;
    });
    _showSnackBar(context,
        "${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
    await Future.delayed(Duration(seconds: 1));
  }

  onFailed() {
    setState(() {
      isLoading = false;
    });
    _showSnackBar(context, "PhoneAuth failed");
  }

  onError() {
    setState(() {
      isLoading = false;
    });
    _showSnackBar(context,
        "PhoneAuth error ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  }

  onAutoRetrievalTimeOut() {
    setState(() {
      isLoading = false;
    });
    _showSnackBar(context, "PhoneAuth autoretrieval timeout");
  }
}
