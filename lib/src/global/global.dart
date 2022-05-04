import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_loader/awesome_loader.dart';

class Assets {
  static String loginVector = 'assets/images/Wavy_Tech-28_Single-10.jpg';
}

String serverKey =
    'AAAAqh1Nstg:APA91bFxv6IjIge1pGr_2qAP9SIqUIpxZ8_0aYS998ZeBfjVux-Mg07cHAMvabyCf3AUiLXNcsLDQ7_4YdYBfRf2bljzOGWZ-ID03EKb3RWNaZNlaOK9zX7kZcngMsex6BwIqlQL9lNH';

SharedPreferences preferences;
const Color appColorYellow = Color(0xFF1A2B5F);
const Color appColorWhite = Colors.white;
const Color appColorBlack = Colors.white;
const Color appColorGreen = Color(0xFF1E3C72);
const Color textFieldBorder = Colors.white;
const Color IndigoColor = Color(0xFF1A237E);
const Color blackcolor = Color(0xff123456);
const Color WhiteColor = Color(0xFFFFFFFF);

var fontFamily = 'harabaraRegular';

String userID = '';
String userEmail = '';
String userName = '';
String userGender = '';
String userDob = '';
String userImg = '';
String userMobile = '';

List<String> likedRestaurent = [];

// String baseUrl() {
//   return 'https://primocysapp.com/eshield_multivendor/api/';
// }

String baseUrl() {
  return 'https://solo1.org/api/';
}

closeKeyboard() {
  return SystemChannels.textInput.invokeMethod('TextInput.hide');
}

dynamic safeQueries(BuildContext context) {
  return (MediaQuery.of(context).size.height >= 812.0 ||
      MediaQuery.of(context).size.height == 812.0 ||
      (MediaQuery.of(context).size.height >= 812.0 &&
          MediaQuery.of(context).size.height <= 896.0 &&
          Platform.isIOS));
}

// ignore: must_be_immutable
class CustomtextField extends StatefulWidget {
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final Function onTap;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function onEditingComplate;
  final Function onSubmitted;

  final dynamic controller;
  final int maxLines;
  final dynamic onChange;
  final String errorText;
  final String hintText;
  final String labelText;
  bool obscureText = false;
  bool readOnly = false;
  bool autoFocus = false;
  final Widget suffixIcon;

  final Widget prefixIcon;
  CustomtextField({
    this.keyboardType,
    this.textCapitalization,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplate,
    this.onSubmitted,
    this.controller,
    this.maxLines,
    this.onChange,
    this.errorText,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  _CustomtextFieldState createState() => _CustomtextFieldState();
}

class _CustomtextFieldState extends State<CustomtextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      onEditingComplete: widget.onEditingComplate,
      onSubmitted: widget.onSubmitted,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      controller: widget.controller,
      onChanged: widget.onChange,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFF7F7F7),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
        errorStyle: TextStyle(color: Colors.red),
        errorText: widget.errorText,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(5),
        ),
        hintText: widget.hintText,
        labelStyle: TextStyle(color: Colors.black, fontSize: 13),
        hintStyle: TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColorYellow, width: 1.8),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textFieldBorder, width: 1.8),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

Widget loader(BuildContext context) {
  return Center(
      child: Material(
    type: MaterialType.transparency,
    child: Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.7),
        ),
        Center(
          child: Container(
            height: 40,
            width: 40,
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(appColorYellow),
                strokeWidth: 3,
              ),
            ),
          ),
        )
      ],
    ),
  ));
}

class CustomButtom extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;
  final TextStyle style;
  CustomButtom({
    this.color,
    this.title,
    this.style,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      color: color,
      child: Text(
        title,
        style: style,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: appColorYellow, width: 1.8),
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: onPressed,
    );
  }
}

// Html applyHtml(context, String html, {TextStyle style}) {
//   return Html(
//     blockSpacing: 0,
//     data: html ?? '',
//     defaultTextStyle: style ??
//         Theme.of(context).textTheme.body2.merge(TextStyle(fontSize: 14)),
//     useRichText: false,
//     customRender: (node, children) {
//       if (node is dom.Element) {
//         switch (node.localName) {
//           case "br":
//             return SizedBox(
//               height: 0,
//             );
//           case "p":
//             return Padding(
//               padding: EdgeInsets.only(top: 0, bottom: 0),
//               child: Container(
//                 width: double.infinity,
//                 child: Wrap(
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   alignment: WrapAlignment.start,
//                   children: children,
//                 ),
//               ),
//             );
//         }
//       }
//       return null;
//     },
//   );
// }
// ignore: must_be_immutable
class CustomButtonIcon extends StatelessWidget {
  final Color color;
  final String title;
  final String image;
  final Function onPressed;
  final TextStyle style;
  CustomButtonIcon({
    this.color,
    this.title,
    this.style,
    this.image,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Image.asset(image, height: 35.0),
                  ),
                  Expanded(
                      flex: 3,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Text(title, style: style)))
                ])),
        style: ElevatedButton.styleFrom(primary: color),
        onPressed: onPressed);

    // RaisedButton(
    //   color: color,
    //   child: Text(
    //     title,
    //     style: style,
    //   ),
    //   shape: RoundedRectangleBorder(
    //     // side: BorderSide(color: appColorYellow, width: 1.8),
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   onPressed: onPressed,
    // );
  }
}

class CustomButton extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;
  final TextStyle style;
  CustomButton({
    this.color,
    this.title,
    this.style,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      color: color,
      child: Text(
        title,
        style: style,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: appColorYellow, width: 1.8),
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: onPressed,
    );
  }
}

Widget ingenieriaTextfield(
    {Widget prefixIcon,
    Function(String) onChanged,
    List<TextInputFormatter> inputFormatters,
    String hintText,
    Function onTap,
    TextEditingController controller,
    int maxLines,
    TextInputType keyboardType}) {
  return TextField(
    controller: controller,
    onTap: onTap,
    inputFormatters: inputFormatters,
    maxLines: maxLines,
    keyboardType: keyboardType,
    onChanged: onChanged,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[500]),
      filled: true,
      contentPadding: EdgeInsets.only(top: 30.0, left: 10.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(0),
      ),
      fillColor: Colors.transparent,
    ),
  );
}

Widget customAppBar({String title, Widget leading}) {
  return AppBar(
      title: Text(title, style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: leading);
}

void errorDialog(BuildContext context, String message, {bool button}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: 10.0),
            Text(message, textAlign: TextAlign.center),
            Container(height: 30.0),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width - 100,
              // ignore: deprecated_member_use
              child: OutlineButton(
                onPressed: button == null
                    ? () => Navigator.pop(context)
                    : () {
                        // Navigator.of(context).pushAndRemoveUntil(
                        //   MaterialPageRoute(
                        //     builder: (context) => Login(),
                        //   ),
                        //   (Route<dynamic> route) => false,
                        // );
                      },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

// class ToastActive {
//   showToast({String msg}) {
//     return Fluttertoast.showToast(
//       msg: msg,
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIos: 3,
//       backgroundColor: Colors.black.withOpacity(0.5),
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }
// }

class Loader {
  void showIndicator(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
            child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.7),
              ),
              Center(
                child: AwesomeLoader(
                  loaderType: AwesomeLoader.AwesomeLoader3,
                  color: appColorYellow,
                ),
              )
            ],
          ),
        ));
      },
    );
  }

  void hideIndicator(BuildContext context) {
    Navigator.pop(context);
  }
}

// ignore: must_be_immutable
class SearchtextField extends StatefulWidget {
  final TextInputType keyboardType;
  final Function onTap;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function onEditingComplate;
  final Function onSubmitted;
  final dynamic controller;
  final int maxLines;
  final dynamic onChange;
  final String errorText;
  final String hintText;
  final String labelText;
  bool obscureText = false;
  bool readOnly = false;
  bool autoFocus = false;
  final Widget suffixIcon;

  final Widget prefixIcon;
  SearchtextField({
    this.keyboardType,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplate,
    this.onSubmitted,
    this.controller,
    this.maxLines,
    this.onChange,
    this.errorText,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  _SearchtextFieldState createState() => _SearchtextFieldState();
}

class _SearchtextFieldState extends State<SearchtextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      onEditingComplete: widget.onEditingComplate,
      onSubmitted: widget.onSubmitted,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChange,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        errorStyle: TextStyle(color: Colors.black),
        errorText: widget.errorText,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        hintText: widget.hintText,
        focusColor: Colors.black,
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.grey[600]),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
