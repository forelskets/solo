// ignore_for_file: unused_field, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:http/http.dart' as http;
import 'package:vendue_vendor/src/models/booking_item_model.dart';
import 'package:vendue_vendor/src/models/booking_title_model.dart';
import 'package:vendue_vendor/src/views/booking_details_bckp.dart';

// ignore: must_be_immutable
class Bookings extends StatefulWidget {
  bool back;
  Bookings({this.back});
  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings>
    with SingleTickerProviderStateMixin {
  double _height, _width, _fixedPadding;
  TitleModel titleModel;
  BookItemModel bookItemModel;

  List<String> title = ['Upcoming', 'Cancel', 'Completed'];
  List<String> ids = ['Confirm', 'Cancel', 'Completed'];
  List<String> icon = [];
  int initPosition = 0;
  String _value = "";

  @override
  void initState() {
    super.initState();
    getProduct(ids[0]);
    // getProductCategory();
  }

  // getProductCategory() async {
  //   try {
  //     Map<String, String> headers = {
  //       'content-type': 'application/x-www-form-urlencoded',
  //     };
  //     var map = new Map<String, dynamic>();
  //     //  map['cat_id'] = "15";

  //     // ignore: close_sinks
  //     final response = await http.post(Uri.parse('https://primocysapp.com/eshield/api/get_all_cat'),
  //         headers: headers, body: map);

  //     var dic = json.decode(response.body);
  //     print(dic);
  //     Map userMap = jsonDecode(response.body);
  //     if (mounted)
  //       setState(() {
  //         titleModel = TitleModel.fromJson(userMap);
  //         for (var i = 0; i < titleModel.categories.length; i++) {
  //           title.add(titleModel.categories[i].cName);
  //           id.add(titleModel.categories[i].id);
  //           icon.add(titleModel.categories[i].img);
  //         }
  //       });
  //     if (titleModel != null) {
  //       getProduct(titleModel.categories[0].id);
  //     }
  //   } on Exception {
  //     Toast.show("No Internet connection", context,
  //         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

  //     throw Exception('No Internet connection');
  //   }
  // }

  getProduct(String status) async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['vid'] = userID;
      map['status'] = status;

      final response = await http.post(
          Uri.parse('${baseUrl()}get_booking_by_vendor'),
          headers: headers,
          body: map);

      var dic = json.decode(response.body);
      print(dic);
      Map userMap = jsonDecode(response.body);
      if (mounted)
        setState(() {
          bookItemModel = BookItemModel.fromJson(userMap);
        });
      print(map.entries);
    } on Exception {
      Toast.show("No Internet connection", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      throw Exception('No Internet connection');
    }
  }

  apicallStatus(String id) async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['id'] = id;
      map['status'] = _value;

      final response = await http.post(
          Uri.parse('${baseUrl()}booking_status_change_by_vendor'),
          headers: headers,
          body: map);

      var dic = json.decode(response.body);
      print(dic);
      print(map.entries);
      Map userMap = jsonDecode(response.body);
      if (dic['response_code'] != '0') {
        print('successfully changed');
        getProduct(ids[0]);
      }
    } on Exception {
      Toast.show("No Internet connection", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      throw Exception('No Internet connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;
    return Scaffold(
      backgroundColor: appColorWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Bookings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: widget.back == true
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (widget.back == true) {
                    Navigator.pop(context);
                  }
                },
              )
            : Container(),
      ),
      body: title.length > 0
          ? Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CustomTabView(
                initPosition: initPosition,
                itemCount: title.length,
                tabBuilder: (context, index) => Tab(
                  text: title[index],
                  // icon: Image.network(
                  //   icon[index],
                  //   height: 30,
                  //   loadingBuilder: (BuildContext context, Widget child,
                  //       ImageChunkEvent loadingProgress) {
                  //     if (loadingProgress == null) return child;
                  //     return Center(
                  //       child: CupertinoActivityIndicator(),
                  //     );
                  //   },
                  // ),
                ),
                pageBuilder: (context, index) =>
                    Container(color: Colors.white, child: serviceWidget()),
                onPositionChange: (index) {
                  setState(() {
                    bookItemModel = null;
                  });
                  print('current position: $index');
                  initPosition = index;
                  getProduct(ids[index]);
                },
                onScroll: (position) => print('$position'),
              ),
            )
          : Center(
              child: loader(context),
            ),
    );
  }

  Widget serviceWidget() {
    return bookItemModel == null
        ? Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(appColorYellow)))
        : bookItemModel.booking != null && bookItemModel.booking.length > 0
            ? Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: bookItemModel.booking.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child:
                            bookingcard(context, bookItemModel.booking[index]));
                  },
                ))
            : Center(
                child: Text(
                  "Don't have any services",
                  style: TextStyle(
                    color: appColorBlack,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
  }

  Widget bookingcard(BuildContext context, Booking bookings) {
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
            // BoxShadow(
            //   color: Colors.black26,
            // ),
            // BoxShadow(
            //   color: Colors.white,
            //   spreadRadius: -0.70,
            //   blurRadius: 5.0,
            // ),
          ], borderRadius: BorderRadius.circular(10)),
          width: _width,
          child: Card(
            color: Colors.grey.shade50,
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
                                bookings.service.serviceName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'harabaraBold',
                                  color: Colors.black,
                                ),
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
                                  Flexible(
                                    child: Text(
                                      bookings.address,
                                      style: TextStyle(
                                          fontFamily: '',
                                          fontSize: 14,
                                          color: Colors.black),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                                    bookings.createDate,
                                    style: TextStyle(
                                        fontFamily: '',
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Pending Amount: \$${bookings.amount}',
                                style: TextStyle(
                                    fontFamily: '',
                                    fontSize: 14,
                                    color: appColorYellow),
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
                                            bookings.service.serviceImage)),
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
                                          builder: (context) =>
                                              BookingDetails()),
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
      ),
    );
  }

  // Widget _dealCard(BuildContext context, Booking deal) {
  //   double _height, _width, _fixedPadding;
  //   _height = MediaQuery.of(context).size.height;
  //   _width = MediaQuery.of(context).size.width;
  //   _fixedPadding = _height * 0.015;

  //   return InkWell(
  //     onTap: () {},
  //     child: Padding(
  //       padding: EdgeInsets.all(_fixedPadding),
  //       child: Material(
  //         elevation: 2.0,
  //         shadowColor: Colors.black,
  //         borderRadius: BorderRadius.circular(5.0),
  //         child: Container(
  //           // height: ScreenUtil.getInstance().setHeight(470),
  //           // height: SizeConfig.blockSizeVertical * 10,
  //           // width: SizeConfig.blockSizeHorizontal * 25,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(5.0),
  //           ),

  //           child: Column(
  //             children: <Widget>[
  //               // SizedBox(
  //               //   height: _height * 0.025,
  //               // ),
  //               Padding(
  //                 padding: EdgeInsets.all(_fixedPadding),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Flexible(
  //                           // flex: 2,
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Container(
  //                                 width: _width * 2.5 / 10,
  //                                 height: _height * 1 / 10,
  //                                 child: ClipRRect(
  //                                   borderRadius: BorderRadius.circular(5.0),
  //                                   child: FittedBox(
  //                                     child: CachedNetworkImage(
  //                                       imageUrl: deal.service.serviceImage,
  //                                       placeholder: (context, url) => Center(
  //                                         child: Container(
  //                                           margin: EdgeInsets.all(70.0),
  //                                           child: CupertinoActivityIndicator(),
  //                                         ),
  //                                       ),
  //                                       errorWidget: (context, url, error) =>
  //                                           Container(
  //                                         height: 5,
  //                                         width: 5,
  //                                         child: Icon(
  //                                           Icons.error,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     fit: BoxFit.cover,
  //                                   ),
  //                                 ),
  //                               ),
  //                               SizedBox(
  //                                 width: _width * 0.020,
  //                               ),
  //                               Flexible(
  //                                 flex: 2,
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   children: [
  //                                     Container(
  //                                       child: Text('Post party cleaning',
  //                                           textAlign: TextAlign.start,
  //                                           overflow: TextOverflow.ellipsis,
  //                                           maxLines: 2,
  //                                           style: TextStyle(
  //                                               letterSpacing: 1.5,
  //                                               fontFamily: 'harabaraBold',
  //                                               fontSize: _width * 0.040,
  //                                               // fontWeight: FontWeight.bold,
  //                                               color: Colors.black)),
  //                                     ),
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(
  //                                           top: 15, left: 0),
  //                                       child: Row(
  //                                         children: [
  //                                           Text('${deal.createDate}',
  //                                               textAlign: TextAlign.start,
  //                                               overflow: TextOverflow.ellipsis,
  //                                               maxLines: 2,
  //                                               style: TextStyle(
  //                                                   fontSize: 14,
  //                                                   fontFamily: 'harabaraBold',
  //                                                   color: Colors.black45)),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     SizedBox(
  //                                       height: 05,
  //                                     ),

  //                                     Text.rich(
  //                                       TextSpan(
  //                                         children: [
  //                                           TextSpan(
  //                                               text: 'Status : ',
  //                                               style: TextStyle(
  //                                                   fontSize: 14,
  //                                                   fontFamily: 'harabaraBold',
  //                                                   color: Colors.black45)),
  //                                           TextSpan(
  //                                               text: '${deal.status}',
  //                                               style: TextStyle(
  //                                                   fontSize: 14,
  //                                                   fontFamily: 'harabaraBold',
  //                                                   color: appColorYellow)),
  //                                         ],
  //                                       ),
  //                                     )
  //                                     // Padding(
  //                                     //   padding: const EdgeInsets.only(
  //                                     //       top: 05, left: 0),
  //                                     //   child: Row(
  //                                     //     children: [
  //                                     //       Text('Status : Pending',
  //                                     //           textAlign: TextAlign.start,
  //                                     //           overflow: TextOverflow.ellipsis,
  //                                     //           maxLines: 2,
  //                                     //           style: TextStyle(
  //                                     //               fontSize: 14,
  //                                     //               fontFamily: 'harabaraBold',
  //                                     //               color: Colors.black45)),
  //                                     //     ],
  //                                     //   ),
  //                                     // ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         deal.status != 'Cancel' && deal.status != 'Completed'
  //                             ? PopupMenuButton(
  //                                 onSelected: (value) {
  //                                   setState(() {
  //                                     _value = value;
  //                                   });
  //                                   apicallStatus(deal.id);
  //                                   print(_value);
  //                                 },
  //                                 itemBuilder: (context) {
  //                                   return [
  //                                     PopupMenuItem(
  //                                       value: 'Cancel',
  //                                       child: Text('Cancel'),
  //                                     ),
  //                                     PopupMenuItem(
  //                                       value: 'Completed',
  //                                       child: Text('Complete'),
  //                                     )
  //                                   ];
  //                                 },
  //                               )
  //                             : Container()
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    @required this.itemCount,
    @required this.tabBuilder,
    @required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  TabController controller;
  int _currentCount;
  int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(
              5.0,
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: TabBar(
            isScrollable: false,
            controller: controller,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.black,
            indicator: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: appColorYellow),
            // indicator: BoxDecoration(
            //   border: Border(
            //     bottom: BorderSide(
            //       color: Colors.black,
            //       width: 2,
            //     ),
            //   ),
            // ),
            tabs: List.generate(
              widget.itemCount,
              (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation.value);
    }
  }
}
