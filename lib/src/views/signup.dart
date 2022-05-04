import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:progress_indicator_button/progress_button.dart';
import 'package:http/http.dart' as http;
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/helper/sizeConfig.dart';
import 'package:vendue_vendor/src/models/gender_model.dart';
import 'package:vendue_vendor/src/models/signup_model.dart';
import 'package:vendue_vendor/src/views/login.dart';
import 'package:vendue_vendor/src/views/validation/validation.dart';
import 'package:vendue_vendor/src/views/webview.dart';
import 'package:vendue_vendor/src/widgets/customdropdown.dart';
import 'package:vendue_vendor/src/widgets/textFieldDatePicker.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _cpasswordFocus = FocusNode();
  bool _conpass = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SignupModel signupModel;
  //String selectDate = "";

  DateTime selectedDate = DateTime.now();
  String birthDate = "";

  bool checkedValue=false;

  final List<GenderModel> _gendertypeList = [
    GenderModel(
      genderType: 'Male',
    ),
    GenderModel(
      genderType: 'Female',
    ),
    GenderModel(
      genderType: 'Other',
    ),
  ];

  GenderModel _gendertypesModel = GenderModel();
  List<DropdownMenuItem<GenderModel>> _genderDropDownListList;
  List<DropdownMenuItem<GenderModel>> _buildGendertypeDropdown(
      List genderList) {
         // ignore: deprecated_member_use
    List<DropdownMenuItem<GenderModel>> items = List();
    for (GenderModel favouriteFoodModel in genderList) {
      items.add(DropdownMenuItem(
        value: favouriteFoodModel,
        child: Text(favouriteFoodModel.genderType),
      ));
    }
    return items;
  }

  _onChangeGenderDropdown(GenderModel favouriteFoodModel) {
    setState(() {
      print(favouriteFoodModel.genderType);
      _gendertypesModel = favouriteFoodModel;
    });
  }

  @override
  void initState() {
    birthDate = DateFormat("dd-MM-yyyy").format(selectedDate);
    _genderDropDownListList = _buildGendertypeDropdown(_gendertypeList);
    _gendertypesModel = _gendertypeList[0];

    super.initState();
  }

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
        key: _scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(
              //     builder: (context) => Login(),
              //   ),
              // );
            },
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
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
      child: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _appIcon(),
                Container(height: 10.0),
                Container(
                  // color: Colors.red,
                  child: Column(
                    children: <Widget>[
                      _usernameTextfield(context),
                      Container(height: 10.0),
                      _emailTextfield(context),
                      Container(height: 10.0),
                      _passwordTextfield(context),
                      Container(height: 10.0),
                      _cpasswordTextfield(context),
                      Container(height: 10.0),
                      _genderTextfild(context),
                      Container(height: 10.0),
                      _datePickerWidget(context),
                      Container(height: 20.0),
                      _termsCondition(context),
                      Container(height: 20.0),
                      _loginButton(context),
                      Container(height: 20.0),
                      // _facebookButton(context),
                    ],
                  ),
                ),
                _dontHaveAnAccount(context),
                Container(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appIcon() {
    return Image.asset(
      "assets/images/eshield.png",
      height: 120,
    );
  }

  Widget _usernameTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Name',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        StreamBuilder<String>(
          stream: validationBloc.username,
          builder: (context, AsyncSnapshot<String> snapshot) {
            return CustomtextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              focusNode: _nameFocus,
              onChange: validationBloc.changeUsername,
              maxLines: 1,
              errorText: snapshot.error,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                // FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(_emailFocus);
              },
            );
          },
        )
      ],
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
        StreamBuilder<String>(
          stream: validationBloc.email,
          builder: (context, AsyncSnapshot<String> snapshot) {
            return CustomtextField(
              controller: _emailController,
              focusNode: _emailFocus,
              onChange: validationBloc.changeEmail,
              maxLines: 1,
              errorText: snapshot.error,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                // FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(_passwordFocus);
              },
            );
          },
        )
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
        StreamBuilder<String>(
          stream: validationBloc.password,
          builder: (context, AsyncSnapshot<String> snapshot) {
            return CustomtextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              onChange: validationBloc.changePassword,
              maxLines: 1,
              errorText: snapshot.error,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              onSubmitted: (value) {
                // FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(_cpasswordFocus);
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
                icon: Icon(_conpass ? Icons.visibility_off : Icons.visibility),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _cpasswordTextfield(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Confirm Password',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        StreamBuilder<String>(
          stream: validationBloc.cpassword,
          builder: (context, AsyncSnapshot<String> snapshot) {
            return CustomtextField(
              controller: _cpasswordController,
              focusNode: _cpasswordFocus,
              onChange: validationBloc.changecPassword,
              maxLines: 1,
              errorText: snapshot.error,
              textInputAction: TextInputAction.go,
              textCapitalization: TextCapitalization.none,
              onSubmitted: (value) {
                FocusScope.of(context).unfocus();
                // FocusScope.of(context).requestFocus(_cpasswordFocus);
              },
              // obscureText: _conpass,
              // suffixIcon: IconButton(
              //   highlightColor: Colors.transparent,
              //   hoverColor: Colors.black,
              //   onPressed: () {
              //     setState(() {
              //       _conpass = !_conpass;
              //     });
              //   },
              //   color: Theme.of(context).focusColor,
              //   icon: Icon(_conpass ? Icons.visibility_off : Icons.visibility),
              // ),
            );
          },
        )
      ],
    );
  }

  Widget _genderTextfild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Gender',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        CustomDropdown(
          dropdownMenuItemList: _genderDropDownListList,
          onChanged: _onChangeGenderDropdown,
          value: _gendertypesModel,
          isEnabled: true,
        ),
        // StreamBuilder<String>(
        //   stream: validationBloc.password,
        //   builder: (context, AsyncSnapshot<String> snapshot) {
        //     return CustomtextField(
        //       controller: _passwordController,
        //       focusNode: _passwordFocus,
        //       onChange: validationBloc.changePassword,
        //       maxLines: 1,
        //       errorText: snapshot.error,
        //       textInputAction: TextInputAction.next,
        //       onSubmitted: (value) {
        //         FocusScope.of(context).unfocus();
        //         FocusScope.of(context).requestFocus(_passwordFocus);
        //       },
        //       obscureText: _conpass,
        //       suffixIcon: IconButton(
        //         highlightColor: Colors.transparent,
        //         hoverColor: Colors.black,
        //         onPressed: () {
        //           setState(() {
        //             _conpass = !_conpass;
        //           });
        //         },
        //         color: Theme.of(context).focusColor,
        //         icon: Icon(_conpass ? Icons.visibility_off : Icons.visibility),
        //       ),
        //     );
        //   },
        // )
      ],
    );
  }

  Widget _datePickerWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            'Date of birth',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),

        //   MyTextFieldDatePicker(
        //   labelText: "Date",
        //   prefixIcon: Icon(Icons.date_range),
        //   suffixIcon: Icon(Icons.arrow_drop_down),
        //   lastDate: DateTime.now().add(Duration(days: 366)),
        //   firstDate: DateTime.now(),
        //   initialDate: DateTime.now().add(Duration(days: 1)),
        //   onDateChanged: (selectedDate) {
        //     // Do something with the selected date
        //   },
        // ),

        MyTextFieldDatePicker(
          prefixIcon: Icon(
            Icons.date_range,
            color: Colors.grey[700],
          ),
          suffixIcon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey[700],
          ),
          firstDate: DateTime(1900),
          lastDate: DateTime(2025),
          initialDate: selectedDate,
          onDateChanged: (updatedDate) {
            // selectedDate = currentTime;
            setState(() {
              birthDate = DateFormat("dd-MM-yyyy").format(updatedDate);

              print(birthDate);
            });
            // Do something with the selected date
          },
        ),
      ],
    );
  }

  _termsCondition(BuildContext context) {
    void _handleURLButtonPress(BuildContext context, String url) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WebViewContainer(url)));
    }

    return CheckboxListTile(
      activeColor: appColorGreen,
      title: Wrap(
        alignment: WrapAlignment.start,
        children: <Widget>[
          Text("By using our app you agree to our ",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.normal,
                color: Colors.black,
              )),
          InkWell(
            onTap: () {
              _handleURLButtonPress(context,
                  "https://eshield.theprimoapp.com/eshield-privacy-policy.html");
            },
            child: Text("Privacy Policy",
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: appColorGreen,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),

      value: checkedValue,
      onChanged: (newValue) {
        print(newValue);
        setState(() {
          checkedValue = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
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
            "Sign Up",
            style: TextStyle(
              color: appColorWhite,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          onPressed: (AnimationController controller) {
            print(birthDate);
            _apicall(controller);
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
    return InkWell(
      onTap: () {
        _showToast();
      },
      child: Text.rich(
        TextSpan(
          text: "Already have an account? ",
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
              text: 'Sign In',
              style: TextStyle(
                  fontFamily: "harabaraBold",
                  fontWeight: FontWeight.w100,
                  color: appColorYellow),
            ),
          ],
        ),
      ),
    );
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

  bool isLoading = false;

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  _apicall(AnimationController controller) async {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (validateStructure(_passwordController.text)) {
      if (regex.hasMatch(_emailController.text)) {
        if (_nameController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty &&
            _passwordController.text == _cpasswordController.text&&
            checkedValue==true) {
          print(birthDate);
          controller.forward();
          var uri = Uri.parse('${baseUrl()}/vendor_register');
          var request = new http.MultipartRequest("POST", uri);
          Map<String, String> headers = {
            "Accept": "application/json",
          };
          request.headers.addAll(headers);
          request.fields['uname'] = _nameController.text;
          request.fields['email'] = _emailController.text;
          request.fields['gender'] = _gendertypesModel.genderType;
          request.fields['date_of_birth'] = birthDate.toString();
          request.fields['password'] = _passwordController.text;

          var response = await request.send();
          print(response.statusCode);

          String responseData =
              await response.stream.transform(utf8.decoder).join();
          var userData = json.decode(responseData);

          signupModel = SignupModel.fromJson(userData);

          if (signupModel.responseCode == "1") {
            controller.reverse();
            _showToast();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Login()),
              (Route<dynamic> route) => false,
            );
          } else {
            controller.reverse();
            _showSnackBar(context, "User already exists");
          }

          // print(responseData);

          // Loader().hideIndicator(context);
        } else {
          if (_nameController.text.isEmpty) {
            controller.reverse();
            _showSnackBar(context, "Enter your name");
          } else if (_emailController.text.isEmpty) {
            controller.reverse();
            _showSnackBar(context, "Enter your email");
          } else if (_passwordController.text.isEmpty) {
            controller.reverse();
          } else if (_passwordController.text != _cpasswordController.text) {
            _showSnackBar(context, "Enter your password");
            controller.reverse();
            _showSnackBar(
                context, "Password didn't match with confirm password");
          }
          else if (checkedValue == false) {
            controller.reverse();
            _showSnackBar(context, "You need to accept terms & condition to contine");
          }
        }
      } else {
        controller.reverse();
        _showSnackBar(context, "Invalid Email, Please enter valid email");
      }
    } else {
      controller.reverse();
      _showSnackBar(context,
          "password must be 6+ charecter long including 1 Upper case, 1 lowercase, 1 Numeric Number, 1 Special Character");
    }
  }

  _showToast() {
    return Fluttertoast.showToast(
        msg: "Registration successful. Please login",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
