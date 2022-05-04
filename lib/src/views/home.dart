import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/models/User_model.dart';
import 'package:vendue_vendor/src/models/product_model.dart';
import 'package:vendue_vendor/src/models/signin_model.dart';
import 'package:vendue_vendor/src/sharedpref/preferencesKey.dart';
import 'package:vendue_vendor/src/views/create_store.dart';
import 'package:vendue_vendor/src/views/edit_store.dart';
import 'package:vendue_vendor/src/views/mynotifications.dart';
import 'package:vendue_vendor/src/views/reviews.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:vendue_vendor/src/views/tabbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductModel productModel;
  SigninModel signinModel;
  Position currentLocation;
  bool likePressed = false;

  Map<String, dynamic> dic;
  bool notLoader = true;

  @override
  void initState() {
    getUserCurrentLocation();
    getUserDataFromPrefs();

    super.initState();
  }

  Future getUserDataFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String userDataStr =
        preferences.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);
    Map<String, dynamic> userData = json.decode(userDataStr);
    signinModel = SigninModel.fromJson(userData);

    setState(() {
      userID = signinModel.userId;
      print(userID);
    });
    _badgeCount();
    _getProducts();
    _getUSer();
  }

  refresh() {
    _getProducts();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future getUserCurrentLocation() async {
    if (mounted)
      await Geolocator.getCurrentPosition().then((position) {
        if (mounted)
          setState(() {
            currentLocation = position;
            print("<><><><><><><" + currentLocation.latitude.toString());
            print("<><><><><><><" + currentLocation.longitude.toString());
          });
      });
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      _getProducts();
    });
  }

  _getProducts() async {
    var uri = Uri.parse('${baseUrl()}/get_v_res');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'vid': userID});
    // request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted)
      setState(() {
        productModel = ProductModel.fromJson(userData);
      });
  }

  _getUSer() async {
    UserModel userModel;

    var uri = Uri.parse('${baseUrl()}/vendor_data');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['vid'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted)
      setState(() {
        userModel = UserModel.fromJson(userData);
      });
    if (userModel != null) {
      userEmail = userModel.user.email;
      userName = userModel.user.uname;
      userGender = userModel.user.gender;
      userDob = userModel.user.dateOfBirth;
      userImg = userModel.user.profileImage;
      userMobile = userModel.user.mobile.toString();
    }
  }

  _getRequests() async {
    _badgeCount();
  }

  _badgeCount() async {
    setState(() {
      notLoader = true;
    });
    try {
      var uri = Uri.parse('${baseUrl()}/vendor_notification_read_count');
      var request = new http.MultipartRequest("POST", uri);

      Map<String, String> headers = {
        "Accept": "application/json",
      };
      request.headers.addAll(headers);
      request.fields.addAll({'v_id': userID});

      var response = await request.send();
      if (response.statusCode == 200) {
        String responseData =
            await response.stream.transform(utf8.decoder).join();
        dic = json.decode(responseData);
        if (dic['response_code'] == '1') {
          print('notification count???????????????');
          print(dic['count']);
        }
        debugPrint('Success Response of notification count : $dic');
      } else {
        debugPrint('Server Not responding properly in notification count');
      }
      setState(() {
        notLoader = false;
      });

      // print(response.statusCode);
      // String responseData =
      //     await response.stream.transform(utf8.decoder).join();
      // var userData = json.decode(responseData);

      // print("+++++++++");
      // print(responseData);
      // print("+++++++++");
    } on Exception {
      setState(() {
        notLoader = false;
      });
      throw Exception('No Internet connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    // _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/shield.jpg",
            height: 30,
          ),
        ),
        title: Text(
          "Store",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                IconButton(
                    icon: Icon(CupertinoIcons.bell),
                    onPressed: () {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(
                              builder: (_) => new Notifications()))
                          .then((val) => val ? _getRequests() : null);
                    }),
                notLoader != true
                    ? dic['count'] != '0'
                        ? new Positioned(
                            right: 9,
                            top: 3,
                            child: new Container(
                              padding: EdgeInsets.all(2),
                              decoration: new BoxDecoration(
                                color: appColorGreen,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 15,
                                minHeight: 15,
                              ),
                              child: Center(
                                child: Text(
                                  '${dic['count']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : new Container()
                    : new Positioned(
                        right: 9,
                        top: 3,
                        child: new Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: appColorGreen,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 15,
                              minHeight: 15,
                            ),
                            child: Container(
                                height: 9,
                                width: 9,
                                child: CircularProgressIndicator(
                                    color: appColorWhite, strokeWidth: 1))),
                      )
              ],
            ),
          ),
          IconButton(
              icon: Icon(CupertinoIcons.add_circled),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StepperDemo()),
                );
              })
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          RefreshIndicator(
            onRefresh: _pullRefresh,
            child: productModel != null && currentLocation != null
                ? _homeList()
                : Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(appColorYellow),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget _homeList() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: AnimationLimiter(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.16,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TabbarScreen(currentIndex: 3)));
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              productModel.bookingCount,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                      color: appColorYellow,
                                      fontFamily: 'harabaraBold',
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Total\nBookings',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 05,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TabbarScreen(currentIndex: 2)));
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              productModel.productsCount,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                      color: appColorYellow,
                                      fontFamily: 'harabaraBold',
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Total\nProducts',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 05,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TabbarScreen(currentIndex: 1)));
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              productModel.servicesCount,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                      color: appColorYellow,
                                      fontFamily: 'harabaraBold',
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Total\nServices',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          productModel.restaurants.length > 0
              ? Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Your Stores",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: productModel.restaurants.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              horizontalOffset: 100.0,
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: _nearByitemCard(context,
                                      productModel.restaurants[index])),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 70),
                    Container(
                      height: 200,
                      width: 200,
                      child: Image.asset(
                        "assets/images/nostores.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      "Store list empty!",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ))
        ],
      ) //Widget,

          ),
    );
  }

  Widget _nearByitemCard(BuildContext context, Restaurants product) {
    double _height, _width, _fixedPadding;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.015;

    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => BidDetailWidget(
        //             productID: product.resId,
        //           )),
        // );
      },
      child: Padding(
        padding: EdgeInsets.all(_fixedPadding),
        child: Material(
          elevation: 2.0,
          shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(14.0),
          child: Container(
            // height: ScreenUtil.getInstance().setHeight(470),
            // height: SizeConfig.blockSizeVertical * 10,
            // width: SizeConfig.blockSizeHorizontal * 25,
            decoration: BoxDecoration(
              color: Color(0xFFF0F3F4),
              borderRadius: BorderRadius.circular(14.0),
            ),

            child: Column(
              children: <Widget>[
                Container(
                  width: _width,
                  height: _height * 2 / 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.0),
                    child: FittedBox(
                      child: CachedNetworkImage(
                        imageUrl: product.allImage[0],
                        placeholder: (context, url) => Center(
                          child: Container(
                            margin: EdgeInsets.all(100.0),
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 5,
                          width: 5,
                          child: Icon(
                            Icons.error,
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // SizedBox(
                //   height: _height * 0.025,
                // ),
                Padding(
                  padding: EdgeInsets.all(_fixedPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.resName,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontFamily: 'harabaraBold',
                                        fontSize: _width * 0.040,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                SizedBox(
                                  height: _height * 0.010,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.location),
                                    SizedBox(
                                      width: _width * 0.010,
                                    ),
                                    Flexible(
                                      child: Column(
                                        children: [
                                          Text(product.resAddress,
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              // mainAxisAlignment:
                              //     MainAxisAlignment.start,
                              // crossAxisAlignment:
                              //     CrossAxisAlignment.end,
                              children: [
                                new Container(
                                  height: _height * 0.030,
                                  width: _width * 1.2 / 10,
                                  decoration: BoxDecoration(
                                      color: appColorYellow,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: appColorWhite,
                                          size: _width * 0.025,
                                        ),
                                        SizedBox(
                                          width: _width * 0.010,
                                        ),
                                        Flexible(
                                          child: Text(
                                            product.resRatings != ""
                                                ? product.resRatings
                                                : "0.0",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: appColorWhite,
                                              fontSize: _width * 0.025,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _width * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          currentLocation != null &&
                                  product.lat != '' &&
                                  product.lon != ''
                              ? Container(
                                  child: Flexible(
                                  child: Column(
                                    children: [
                                      Text(
                                        calculateDistance(
                                                    currentLocation.latitude,
                                                    currentLocation.longitude,
                                                    double.parse(product.lat),
                                                    double.parse(product.lon))
                                                .toStringAsFixed(0) +
                                            "km",
                                        style: TextStyle(
                                            fontFamily: 'harabaraBold',
                                            fontSize: _width * 0.035),
                                      ),
                                    ],
                                  ),
                                ))
                              : Container(),
                          Row(
                            children: [
                              SizedBox(
                                width: _width * 2 / 10,
                                height: _height * 0.35 / 10,
                                child: ElevatedButton(
                                  child: Text(
                                    'Edit',
                                    style:
                                        TextStyle(fontFamily: 'harabaraBold'),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProduct(
                                              productId: product.resId,
                                              refresh: refresh)),
                                    );
                                    print('Pressed');
                                  },
                                ),
                              ),
                              SizedBox(
                                width: _width * 0.025,
                              ),
                              SizedBox(
                                height: _height * 0.35 / 10,
                                width: _width * 2.2 / 10,
                                child: ElevatedButton(
                                  child: Text(
                                    'Review',
                                    style: TextStyle(
                                        fontFamily: 'harabaraBold',
                                        color: appColorWhite),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: appColorYellow,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReviewScreen(
                                                productId: product.resId,
                                              )),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      )
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
}
