import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/helper/sizeConfig.dart';
import 'package:vendue_vendor/src/models/updateuser_model.dart';
import 'package:vendue_vendor/src/sharedpref/preferencesKey.dart';
import 'package:vendue_vendor/src/views/bookings.dart';
import 'package:vendue_vendor/src/views/chat/fireChatList.dart';
import 'package:vendue_vendor/src/views/editprofile.dart';
import 'package:vendue_vendor/src/views/login.dart';
import 'package:vendue_vendor/src/views/mynotifications.dart';
import 'package:vendue_vendor/src/views/webview.dart';
import 'package:vendue_vendor/src/views/welcom.dart';

import 'google signin/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  final String logo = Assets.loginVector;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  DateTime dt;

  String birthDate = "";
  UpdateUserModel updateUserModel;
  bool isLoading = false;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  _getRequests() async {}

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/shield.jpg",
                height: 40,
              ),
            ),
            title: Text(
              "Profile",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: userID != '0'
              ? Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  appColorYellow),
                            ),
                          )
                        : _body(context),
                  ],
                )
              : Stack(
                  children: <Widget>[
                    Container(
                      width: SizeConfig.screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            widget.logo,
                            width: SizeConfig.blockSizeHorizontal * 100,
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 5,
                          ),
                          ElevatedButton(
                            child: Text('Click here to login'),
                            style: ElevatedButton.styleFrom(
                              primary: appColorYellow,
                              onPrimary: Colors.white,
                              shape: const BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => WelcomeScreen(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 0.0,
                  ),
                  _exploreWidget(),
                  _personalDetails(),
                  // Divider(),
                  // _myPayment(),
                  Divider(),
                  _myNotifications(),
                  Divider(),
                  _bookings(),
                  Divider(),
                  _myChats(),
                  Divider(),
                  _privacypolicy(),
                  Divider(),
                  _transactions(),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _personalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.secondary,
            focusColor: Theme.of(context).colorScheme.secondary,
            highlightColor: Theme.of(context).primaryColor,

            onTap: () => Navigator.of(context)
                .push(
                  new MaterialPageRoute(builder: (_) => new EditProfile()),
                )
                .then((val) => val ? _getRequests() : null),
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => EditProfile()),
            // );

            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   border: Border.all(
              //       color: Colors.black54, width: 1.5),
              //   borderRadius: BorderRadius.circular(5),
              //   boxShadow: [
              //     BoxShadow(
              //         color: Theme.of(context)
              //             .focusColor
              //             .withOpacity(0.1),
              //         blurRadius: 5,
              //         offset: Offset(0, 2)),
              //   ],
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                    size: 35,
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('My Details',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Click Here to see your personal details',
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_right, color: appColorYellow),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _myPayment() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(bottom: 10),
  //         child: InkWell(
  //           splashColor: Theme.of(context).accentColor,
  //           focusColor: Theme.of(context).accentColor,
  //           highlightColor: Theme.of(context).primaryColor,
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => EditBankdetails()),
  //             );
  //           },
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //             // decoration: BoxDecoration(
  //             //   color: Colors.white,
  //             //   border: Border.all(
  //             //       color: Colors.black54, width: 1.5),
  //             //   borderRadius: BorderRadius.circular(5),
  //             //   boxShadow: [
  //             //     BoxShadow(
  //             //         color: Theme.of(context)
  //             //             .focusColor
  //             //             .withOpacity(0.1),
  //             //         blurRadius: 5,
  //             //         offset: Offset(0, 2)),
  //             //   ],
  //             // ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: <Widget>[
  //                 Icon(
  //                   CupertinoIcons.money_dollar_circle,
  //                   color: Colors.grey,
  //                   size: 35,
  //                 ),
  //                 SizedBox(width: 15),
  //                 Flexible(
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: <Widget>[
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: <Widget>[
  //                             Text('Bank Details',
  //                                 overflow: TextOverflow.ellipsis,
  //                                 maxLines: 2,
  //                                 style: TextStyle(
  //                                     color: Colors.black45,
  //                                     fontSize:
  //                                         SizeConfig.blockSizeHorizontal * 4,
  //                                     fontWeight: FontWeight.bold)),
  //                             SizedBox(
  //                               height: 2,
  //                             ),
  //                             Text(
  //                               'Click Here to see your Bank details',
  //                               overflow: TextOverflow.fade,
  //                               softWrap: false,
  //                               style: Theme.of(context).textTheme.caption,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       SizedBox(width: 8),
  //                       Icon(Icons.keyboard_arrow_right, color: appColorYellow),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _myNotifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.secondary,
            focusColor: Theme.of(context).colorScheme.secondary,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Notifications()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   border: Border.all(
              //       color: Colors.black54, width: 1.5),
              //   borderRadius: BorderRadius.circular(5),
              //   boxShadow: [
              //     BoxShadow(
              //         color: Theme.of(context)
              //             .focusColor
              //             .withOpacity(0.1),
              //         blurRadius: 5,
              //         offset: Offset(0, 2)),
              //   ],
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    CupertinoIcons.bell,
                    color: Colors.grey,
                    size: 35,
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Notifications',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Click Here to see your notifications',
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_right, color: appColorYellow),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _myChats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.secondary,
            focusColor: Theme.of(context).colorScheme.secondary,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FireChatList()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   border: Border.all(
              //       color: Colors.black54, width: 1.5),
              //   borderRadius: BorderRadius.circular(5),
              //   boxShadow: [
              //     BoxShadow(
              //         color: Theme.of(context)
              //             .focusColor
              //             .withOpacity(0.1),
              //         blurRadius: 5,
              //         offset: Offset(0, 2)),
              //   ],
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    CupertinoIcons.chat_bubble_text,
                    color: Colors.grey,
                    size: 35,
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Chat',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Click Here to see your chats',
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_right, color: appColorYellow),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

   Widget _privacypolicy() {
     void _handleURLButtonPress(BuildContext context, String url) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WebViewContainer(url)));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.secondary,
            focusColor: Theme.of(context).colorScheme.secondary,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () {
              _handleURLButtonPress(context,
                  "https://eshield.theprimoapp.com/eshield-privacy-policy.html");
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   border: Border.all(
              //       color: Colors.black54, width: 1.5),
              //   borderRadius: BorderRadius.circular(5),
              //   boxShadow: [
              //     BoxShadow(
              //         color: Theme.of(context)
              //             .focusColor
              //             .withOpacity(0.1),
              //         blurRadius: 5,
              //         offset: Offset(0, 2)),
              //   ],
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.description_outlined,
                    color: Colors.grey,
                    size: 35,
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Privacy Poilicy',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Click Here to see Privacy Policy',
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_right, color: appColorYellow),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bookings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.secondary,
            focusColor: Theme.of(context).colorScheme.secondary,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BookingList(
                        back: true,
                      )));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    CupertinoIcons.list_number,
                    color: Colors.grey,
                    size: 30,
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Bookings',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Click Here to see your bookings',
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_right, color: appColorYellow),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _transactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.secondary,
            focusColor: Theme.of(context).colorScheme.secondary,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () async {
              signOutGoogle();
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear();
              userID = '';
              preferences
                  .remove(SharedPreferencesKey.LOGGED_IN_USERRDATA)
                  .then((_) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                  (Route<dynamic> route) => false,
                );
                // Navigator.of(context, rootNavigator: true)
                //     .pop();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    CupertinoIcons.escape,
                    color: Colors.grey,
                    size: 30,
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Logout',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Click Here to exit app ',
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_right, color: appColorYellow),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _exploreWidget() {
    return Column(
      children: [
        userImg != ""
            ? Stack(
                children: [
                  CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black45,
                      backgroundImage: NetworkImage(userImg)),
                ],
              )
            : Container(
                height: 120,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey[300]),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/user.png",
                    color: appColorYellow,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 1,
        ),
        userName != ""
            ? Text(
                userName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.blockSizeHorizontal * 4),
              )
            : Container(),
        SizedBox(height: SizeConfig.blockSizeVertical * 5),
      ],
    );
  }

  selectImageSource() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          content: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(height: 10.0),
                  Text(
                    "Pick Image",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(height: 20.0),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      getImageFromCamera();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.camera_alt,
                          color: appColorYellow,
                        ),
                        Container(width: 10.0),
                        Text('Camera')
                      ],
                    ),
                  ),
                  Container(height: 15.0),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      getImageFromGallery();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.storage,
                          color: appColorYellow,
                        ),
                        Container(width: 10.0),
                        Text('Gallery')
                      ],
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child: ClipOval(
                    child: Material(
                      elevation: 5,
                      color: appColorYellow, // button color
                      child: InkWell(
                        splashColor: Colors.red, // inkwell color
                        child: SizedBox(
                            width: 25,
                            height: 25,
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.white,
                            )),
                        onTap: () {
                          closeKeyboard();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // selectImageSource() {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(
  //             Radius.circular(8.0),
  //           ),
  //         ),
  //         content: Stack(
  //           children: [
  //             Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: <Widget>[
  //                 Container(height: 10.0),
  //                 Text(
  //                   "Pick Image",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(fontWeight: FontWeight.bold),
  //                 ),
  //                 Container(height: 20.0),
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     getImageFromCamera();
  //                   },
  //                   child: Row(
  //                     children: <Widget>[
  //                       Icon(
  //                         Icons.camera_alt,
  //                         color: appColorYellow,
  //                       ),
  //                       Container(width: 10.0),
  //                       Text('Camera')
  //                     ],
  //                   ),
  //                 ),
  //                 Container(height: 15.0),
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     getImageFromGallery();
  //                   },
  //                   child: Row(
  //                     children: <Widget>[
  //                       Icon(
  //                         Icons.storage,
  //                         color: appColorYellow,
  //                       ),
  //                       Container(width: 10.0),
  //                       Text('Gallery')
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Positioned.fill(
  //               child: Align(
  //                 alignment: Alignment.topRight,
  //                 child: ClipOval(
  //                   child: Material(
  //                     elevation: 5,
  //                     color: appColorYellow, // button color
  //                     child: InkWell(
  //                       splashColor: Colors.red, // inkwell color
  //                       child: SizedBox(
  //                           width: 25,
  //                           height: 25,
  //                           child: Icon(
  //                             Icons.close,
  //                             size: 20,
  //                             color: Colors.white,
  //                           )),
  //                       onTap: () {
  //                         closeKeyboard();
  //                         Navigator.pop(context);
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
