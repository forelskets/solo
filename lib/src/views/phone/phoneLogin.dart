import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/helper/sizeConfig.dart';
import 'package:vendue_vendor/src/models/countryCode_modal.dart';
import 'package:vendue_vendor/src/views/country_code/bloc/country_code_bloc.dart';
import 'package:vendue_vendor/src/views/country_code/reuseble/country_code_picker.dart';
import 'package:vendue_vendor/src/views/phone/phone_auth.dart';
import 'package:vendue_vendor/src/views/phone/verify.dart';

class PhoneLogin extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<PhoneLogin> {
  String verificationId;
  String cc = '+91';
  String numberPrefix;
  //final _phoneNumberController = TextEditingController();
  ConfirmationResult webConfirmationResult;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  CountryCodeModal countryCodeModal;
  TextEditingController controller = new TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // getCode();

    super.initState();
  }

  // getCode() async {
  //   var uri = Uri.parse('${baseUrl()}/get_all_country_code');
  //   var request = new http.MultipartRequest("GET", uri);
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //   };
  //   request.headers.addAll(headers);
  //   //request.fields.addAll({'user_id': userID});

  //   var response = await request.send();
  //   print(response.statusCode);
  //   String responseData = await response.stream.transform(utf8.decoder).join();
  //   var userData = json.decode(responseData);
  //   if (mounted) {
  //     setState(() {
  //       countryCodeModal = CountryCodeModal.fromJson(userData);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(color: appColorWhite),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: appColorWhite,
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _signupForm(context),
          ],
        ),
      ),
    );
  }

  Widget _signupForm(BuildContext context) {
    return Center(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              applogo(),
              Container(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Sign in with your phone number",
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
                    Container(
                      child: Text(
                        "Enter phone number below to continue.",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 30.0),
              _userTextfield(context),
              Container(height: 30.0),
              _submitButton(context),
              Container(height: 40.0),
              _dontHaveAnAccount(context),
              Container(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_element

  Widget applogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/eshield.png',
          height: 150,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget _userTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
          controller: Provider.of<PhoneAuthDataProvider>(context, listen: false)
              .phoneNumberController,
          maxLines: 1,
          labelText: "Phone Number",
          hintText: "",
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.sentences,
          focusNode: focusNode,
          prefixIcon: InkWell(
            onTap: () {
              return showDialog<void>(
                context: context,
                // barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return CountryPicker();
                },
              );
            },
            child: StreamBuilder<String>(
                stream: countryClodeBloc.codeStream,
                initialData: "+91",
                builder: (context, AsyncSnapshot<String> codeValue) {
                  numberPrefix = codeValue.data ?? "+91";

                  return Padding(
                    padding: const EdgeInsets.only(top: 14, left: 10.0),
                    child: Text(
                      codeValue.data,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  );
                }),
          ),
          //  CountryCodePicker(
          //   initialSelection: '+91',
          //   showCountryOnly: false,
          //   alignLeft: false,
          //   showFlag: false,
          //   padding: const EdgeInsets.all(8),
          //   textStyle: TextStyle(fontSize: 14, color: appColorBlack),
          //   onChanged: _onCountryChange,
          // ),
          ),
    );
  }

  // void _onCountryChange(CountryCode countryCode) {
  //   print("New Country selected: " + countryCode.toString());
  //   setState(() {
  //     cc = countryCode.toString();
  //   });
  // }

  // getCounty() {
  //   showModalBottomSheet(
  //       context: context,
  //       shape: RoundedRectangleBorder(),
  //       isScrollControlled: true,
  //       backgroundColor: Colors.transparent,
  //       builder: (context) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState1) {
  //           return DraggableScrollableSheet(
  //             initialChildSize: 0.8,
  //             builder:
  //                 (BuildContext context, ScrollController scrollController) {
  //               return Container(
  //                 height: SizeConfig.screenHeight,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(20.0),
  //                     topRight: Radius.circular(20.0),
  //                   ),
  //                   color: Colors.white,
  //                 ),
  //                 child: Column(
  //                   children: <Widget>[
  //                     Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.only(
  //                           topLeft: Radius.circular(20.0),
  //                           topRight: Radius.circular(20.0),
  //                         ),
  //                       ),
  //                       height: 60,
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(
  //                             left: 15, right: 15, top: 5),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             InkWell(
  //                                 onTap: () {
  //                                   Navigator.pop(context);
  //                                 },
  //                                 child: Text(
  //                                   "Cancel",
  //                                   textAlign: TextAlign.start,
  //                                   style: TextStyle(color: Colors.black),
  //                                 )),
  //                             Text(
  //                               "Select Country",
  //                               maxLines: 1,
  //                               overflow: TextOverflow.ellipsis,
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.bold,
  //                                   fontStyle: FontStyle.normal,
  //                                   color: Colors.black),
  //                             ),
  //                             Container(width: 40)
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(10),
  //                       child: SearchtextField(
  //                         controller: controller,
  //                         onChange: (val) {
  //                           setState1(() {});
  //                         },
  //                         maxLines: 1,
  //                         textInputAction: TextInputAction.next,
  //                         hintText: 'Search',
  //                         prefixIcon: Container(
  //                           margin: EdgeInsets.all(0.0),
  //                           child: Icon(
  //                             Icons.search,
  //                             color: Colors.black,
  //                             size: 20.0,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Expanded(
  //                         child: ListView.builder(
  //                       itemCount: countryCodeModal.countryCode.length,
  //                       itemBuilder: (BuildContext context, int index) {
  //                         return countryCodeModal.countryCode[index].countryName
  //                                     .contains(new RegExp(controller.text,
  //                                         caseSensitive: false)) ||
  //                                 controller.text.isEmpty
  //                             ? itemWidget(countryCodeModal.countryCode[index])
  //                             : Container();
  //                       },
  //                     )),
  //                   ],
  //                 ),
  //               );
  //             },
  //           );
  //         });
  //       });
  // }

  // Widget itemWidget(CountryCode list) {
  //   return Row(
  //     children: [
  //       Container(width: 10),
  //       Expanded(
  //         child: Column(
  //           children: <Widget>[
  //             ListTile(
  //               onTap: () {
  //                 setState(() {
  //                   cc = list.countryCode;
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               title: Text(
  //                 list.countryName + " ${list.countryCode}",
  //                 style: new TextStyle(
  //                     fontSize: 16.0,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black),
  //               ),
  //             ),
  //             Divider(
  //               height: 1,
  //             ),
  //           ],
  //         ),
  //       ),
  //       Container(width: 10)
  //     ],
  //   );
  // }

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
          onPressed: () {
            validateMobile(
                Provider.of<PhoneAuthDataProvider>(context, listen: false)
                    .phoneNumberController
                    .text);
          },
        ),
      ),
    );
  }

  String validateMobile(String value) {
    if (value.length == 0) {
      Toast.show("Please enter mobile number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return 'Please enter mobile number';
    } else {
      startPhoneAuth();
    }
    return null;
  }

  startPhoneAuth() async {
    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);
    phoneAuthDataProvider.loading = true;

    bool validPhone = await phoneAuthDataProvider.instantiate(
        dialCode: numberPrefix,
        onCodeSent: () {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
              builder: (BuildContext context) => PhoneAuthVerify()));
        },
        onFailed: () {
          _showSnackBar(context, phoneAuthDataProvider.message);
        },
        onError: () {
          _showSnackBar(context, phoneAuthDataProvider.message);
        });
    if (!validPhone) {
      phoneAuthDataProvider.loading = false;
      _showSnackBar(context, "Oops! Number seems invaild");
      return;
    }
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

  Widget _dontHaveAnAccount(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Text.rich(
        TextSpan(
          text: "Already have an account? ",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Sign in',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
