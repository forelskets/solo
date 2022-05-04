// ignore_for_file: unused_field, unused_element

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/models/booking_details.dart';

// ignore: must_be_immutable
class BookingDetails extends StatefulWidget {
  String id;
  BookingDetails({this.id});

  @override
  _BookingDetailsState createState() => _BookingDetailsState(id: id);
}

class _BookingDetailsState extends State<BookingDetails> {
  String id;
  _BookingDetailsState({this.id});
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool likePressed = false;
  DetailsModel detailsModel;

  double _height, _width, _fixedPadding;
  var selectImg = "";

  @override
  void initState() {
    // _tabController.addListener(_smoothScrollToTop);
    _getProductsDetails();
    super.initState();
  }

  _getProductsDetails() async {
    if (likePressed == false) {
      setState(() {
        isLoading = true;
      });
    } else {
      isLoading = false;
    }

    var uri = Uri.parse('http://cafeply.com/api/get_store_details');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'user_id': '1', 'store_id': '9'});

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    detailsModel = DetailsModel.fromJson(userData);

    selectImg = detailsModel.store.storeImage[0];
    print("+++++++++");
    print(responseData);
    print("+++++++++");
    if (detailsModel.responseCode != '0') {
      // var format = DateFormat("HH:mm");
      // var one = format.parse(detailsModel!.store!.mondayFrom!);
      // var two = format.parse(detailsModel!.store!.mondayTo!);
      // print("::::::::::::::::::diff:::::::::::::");
      // print("${two.difference(one)}");

      print("::::::::::::::::::diff:::::::::::::");
    }
    if (mounted)
      setState(() {
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.015;
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage("assets/images/Homepage_coffee.png"),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Details',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        // backgroundColor: Colors.transparent,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(appColorYellow),
                ),
              )
            : CupertinoScrollbar(
                // thickness: 1,
                // thicknessWhileDragging: 1,
                child: CustomScrollView(slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Stack(
                      children: <Widget>[
                        _topContainer(),
                        _middlecard(),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // SliverFillRemaining(
                  //     hasScrollBody: false,
                  //     fillOverscroll:
                  //         true, // Set true to change overscroll behavior. Purely preference.
                  //     child: Align(
                  //       alignment: Alignment.bottomCenter,
                  //       child: SingleChildScrollView(
                  //         physics: NeverScrollableScrollPhysics(),
                  //         child: Container(
                  //           // height: _height * 2 / 10,
                  //           padding: EdgeInsets.symmetric(
                  //               horizontal: 20, vertical: 20),
                  //           decoration: BoxDecoration(
                  //               // color: Colors.black,
                  //               ),
                  //           child: SizedBox(
                  //             child: Column(
                  //               children: <Widget>[],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ))
                ]),
              ),
      ),
    );
  }

  Widget _topContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        // borderRadius: BorderRadius.only(
                        //   bottomRight: Radius.circular(40),
                        // ),
                        child: CachedNetworkImage(
                          imageUrl: selectImg,
                          fit: BoxFit.cover,
                          height: _height * 2.7 / 10,
                          width: _width,
                          placeholder: (context, url) => Center(
                            child: Container(
                              // margin: EdgeInsets.all(70.0),
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
                      ),
                      // Positioned(
                      //   child: Container(
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //       color: appColorYellow,
                      //       borderRadius: BorderRadius.vertical(
                      //         top: Radius.circular(20),
                      //       ),
                      //     ),
                      //   ),
                      //   bottom: 0,
                      //   left: 0,
                      //   right: 0,
                      // ),
                    ],
                  ),
                  _productinfo(),
                  // SizedBox(height: 100),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _verticalImage(var store) {
    return InkWell(
      onTap: () {
        setState(() {
          selectImg = store;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          child: CachedNetworkImage(
            imageUrl: store,
            height: _height * 0.50 / 10,
            width: _width * 2 / 10,
            fit: BoxFit.cover,
            placeholder: (context, url) => Image.asset(
              'assets/images/loading.gif',
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _middlecard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: _height / 4.7),
      child: Container(
        height: _height * 1 / 10,
        width: _width,
        child: Center(
          child: ListView.builder(
            // physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: detailsModel.store.storeImage.length,
            itemBuilder: (context, index) {
              return _verticalImage(detailsModel.store.storeImage[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategory() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          detailsModel.store.storeName ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _width * 0.040,
          ),
        ),
        // SizedBox(height: 4),
        // detailsModel!.store!.openStatus != 'false'
        //     ? Text(
        //         'Open Now',
        //         style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Colors.green,
        //           fontSize: _width * 0.035,
        //         ),
        //       )
        //     : Text(
        //         'Close Now',
        //         style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Colors.red,
        //           fontSize: _width * 0.035,
        //         ),
        //       ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.star_fill,
              color: appColorYellow,
              size: 15,
            ),
            SizedBox(width: 4),
            Text(
              detailsModel.store.storeRatings ?? '',
              style: TextStyle(fontSize: _width * 0.035),
            ),
            SizedBox(width: 4),
            Text(
              '(${detailsModel.review.length.toString()})',
              style: TextStyle(fontSize: _width * 0.03),
            ),
          ],
        ),
        // SizedBox(height: 4),
        // Text(
        //   'Open Now',
        //   style: TextStyle(fontSize: _width * 0.04, color: Colors.green),
        // ),
      ],
    );
  }

  Widget _iconLocation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          CupertinoIcons.location,
          color: Colors.black,
          size: 20,
        ),
        SizedBox(height: 4),
      ],
    );
  }

  Widget _productinfo() {
    return Padding(
      padding: EdgeInsets.only(
          top: _height * 0.60 / 10, left: _width * 0.06, right: _width * 0.06),
      child: Column(
        children: [_servicebasic(context)],
      ),
    );
  }

  Widget _servicebasic(BuildContext context) {
    // var date =
    //     DateTime.fromMillisecondsSinceEpoch(int.parse(reviews.revDate!) * 1000);
    // var formattedDate = DateFormat('MM/dd, hh:mm a').format(date);
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => CategoryItems(
        //           catName: categories.cName, catID: categories.id)),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black26,
            ),
            BoxShadow(
              color: Colors.white,
              spreadRadius: -0.70,
              blurRadius: 5.0,
            ),
          ], borderRadius: BorderRadius.circular(10)),
          width: _width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: _height * 0.020,
                    right: _height * 0.020,
                    top: _height * 0.020,
                    bottom: _height * 0.020),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Service name",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'harabaraBold',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/location book.png',
                                  width: _width * 0.060,
                                ),
                                Text(
                                  'Service Address',
                                  style: TextStyle(
                                      fontFamily: '',
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/Calendar Book.png',
                                  width: _width * 0.060,
                                ),
                                Text(
                                  'Date of booking',
                                  style: TextStyle(
                                      fontFamily: '',
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Pending Amount: \$200',
                              style: TextStyle(
                                  fontFamily: '',
                                  fontSize: 14,
                                  color: appColorYellow,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 100,
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          detailsModel.store.storeImage[0])),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 90,
                              child: ElevatedButton(
                                child: Text(
                                  'More Info',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: _width * 0.023),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: appColorYellow,
                                ),
                                onPressed: () {
                                  print('Pressed');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookingDetails()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Icon(
                      //   CupertinoIcons.ellipsis,
                      //   color: Colors.black45,
                      // ),
                    ],
                  ),
                ),
              ),

              // reviews.revText != ''
              //     ? Padding(
              //         padding: EdgeInsets.all(_height * 0.015),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             // Text(
              //             //   'Recommended Place',
              //             //   style: TextStyle(
              //             //       fontSize: 14,
              //             //       color: Colors.black,
              //             //       fontWeight: FontWeight.bold),
              //             // ),
              //             // SizedBox(
              //             //   height: _height * 0.15 / 10,
              //             // ),

              //             // SizedBox(
              //             //   height: _height * 0.10 / 10,
              //             // ),
              //             Text(
              //               reviews.revText!,
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 color: Colors.black,
              //               ),
              //             ),
              //             SizedBox(
              //               height: _height * 0.10 / 10,
              //             ),
              //           ],
              //         ),
              //       )
            ],
          ),
        ),
      ),
    );
  }
}
