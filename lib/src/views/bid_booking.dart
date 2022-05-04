import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:vendue_vendor/src/global/global.dart';

class BidAndBook extends StatefulWidget {
  @override
  _BidAndBookState createState() => _BidAndBookState();
}

class _BidAndBookState extends State<BidAndBook> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height, _width;
  bool isLoading = false;
  bool refresh = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
  
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Container(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: _height * 0.60 / 10,
                        ),
                        Container(
                          width: _width * 7 / 10,
                          height: _height * 0.50 / 10,
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[100]),
                          child: Center(
                            child: TabBar(
                              labelColor: Colors.black,

                              // isScrollable: true,
                              labelStyle: TextStyle(
                                  fontSize: 13.0, fontFamily: "MontserratBold"),

                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: appColorYellow),

                              tabs: <Widget>[
                                Tab(
                                  text: 'Bidding',
                                ),
                                Tab(
                                  text: 'Booking',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: <Widget>[_bidding(), _booking()],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bidding() {
    return Padding(
      padding: EdgeInsets.all(_height * 0.010),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: FadeInAnimation(child: _biddingCard(context))),
            ),
          );
        },
      ),
    );
  }

  Widget _biddingCard(BuildContext context) {
    double _height, _width, _fixedPadding;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.015;

    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => DetailWidget()),
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
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.info_circle),
                                    SizedBox(
                                      width: 05,
                                    ),
                                    Text('Bidder 567',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontFamily: 'harabaraBold',
                                            fontSize: _width * 0.040,
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ],
                                ),
                                SizedBox(
                                  height: _height * 0.010,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Icon(CupertinoIcons.location),
                                    // SizedBox(
                                    //   width: _width * 0.010,
                                    // ),
                                    Flexible(
                                      child: Column(
                                        children: [
                                          Text(DateTime.now().toString(),
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
                                new Text(
                                  "\$400",
                                  style: TextStyle(
                                    fontFamily: 'harabaraBold',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: _width * 0.035,
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Container(
                          //     child: Flexible(
                          //   child: Column(
                          //     children: [
                          //       Text(
                          //         '2 kms',
                          //         style: TextStyle(
                          //             fontFamily: 'harabaraBold',
                          //             fontSize: _width * 0.035),
                          //       ),
                          //     ],
                          //   ),
                          // )),
                          Row(
                            children: [
                              SizedBox(
                                width: _width * 2 / 10,
                                height: _height * 0.35 / 10,
                                child: ElevatedButton(
                                  child: Text(
                                    'Accept',
                                    style: TextStyle(
                                        fontFamily: 'harabaraBold',
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  onPressed: () {
                                    print('Pressed');
                                  },
                                ),
                              ),
                              SizedBox(
                                width: _width * 0.025,
                              ),
                              SizedBox(
                                height: _height * 0.35 / 10,
                                width: _width * 2.1 / 10,
                                child: ElevatedButton(
                                  child: Text(
                                    'Reject',
                                    style: TextStyle(
                                        fontFamily: 'harabaraBold',
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  onPressed: () {
                                    print('Pressed');
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

  Widget _booking() {
    return Padding(
      padding: EdgeInsets.all(_height * 0.010),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: FadeInAnimation(child: _bookingCard(context))),
            ),
          );
        },
      ),
    );
  }

  Widget _bookingCard(BuildContext context) {
    double _height, _width, _fixedPadding;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.015;

    return Padding(
      padding: EdgeInsets.all(_fixedPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateTime.now().toString(),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  fontSize: _width * 0.030,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(
            height: _height * 0.015,
          ),
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => DetailWidget()),
              // );
            },
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
                                    Row(
                                      children: [
                                        Icon(CupertinoIcons.house_alt),
                                        SizedBox(
                                          width: 05,
                                        ),
                                        Text('Bidder 567',
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontFamily: 'harabaraBold',
                                                fontSize: _width * 0.040,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: _height * 0.010,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Icon(CupertinoIcons.location),
                                        // SizedBox(
                                        //   width: _width * 0.010,
                                        // ),
                                        Flexible(
                                          child: Column(
                                            children: [
                                              RichText(
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                text: TextSpan(
                                                  text: 'Bought Service :',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: ' Fillers',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                appColorYellow)),
                                                  ],
                                                ),
                                              ),
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
                                    new Text(
                                      "\$400",
                                      style: TextStyle(
                                        fontFamily: 'harabaraBold',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: _width * 0.035,
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
                            children: [
                              Icon(
                                CupertinoIcons.time,
                                size: 15,
                              ),
                              SizedBox(
                                width: 05,
                              ),
                              Text('2:00 PM',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: 'harabaraBold',
                                      fontSize: _width * 0.030,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                          SizedBox(
                            height: _width * 0.025,
                          ),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.location,
                                size: 15,
                              ),
                              SizedBox(
                                width: 05,
                              ),
                              Text('Tomtebogatan 8 , 11339, Stockholm',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: 'harabaraBold',
                                      fontSize: _width * 0.030,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     // Row(
                          //     //   children: [
                          //     //     SizedBox(
                          //     //       width: _width * 2 / 10,
                          //     //       height: _height * 0.35 / 10,
                          //     //       child: ElevatedButton(
                          //     //         child: Text(
                          //     //           'Accept',
                          //     //           style: TextStyle(
                          //     //               fontFamily: 'harabaraBold',
                          //     //               color: Colors.white),
                          //     //         ),
                          //     //         style: ElevatedButton.styleFrom(
                          //     //           primary: Colors.green,
                          //     //         ),
                          //     //         onPressed: () {
                          //     //           print('Pressed');
                          //     //         },
                          //     //       ),
                          //     //     ),
                          //     //     SizedBox(
                          //     //       width: _width * 0.025,
                          //     //     ),
                          //     //     SizedBox(
                          //     //       height: _height * 0.35 / 10,
                          //     //       width: _width * 2.1 / 10,
                          //     //       child: ElevatedButton(
                          //     //         child: Text(
                          //     //           'Reject',
                          //     //           style: TextStyle(
                          //     //               fontFamily: 'harabaraBold',
                          //     //               color: Colors.white),
                          //     //         ),
                          //     //         style: ElevatedButton.styleFrom(
                          //     //           primary: Colors.red,
                          //     //         ),
                          //     //         onPressed: () {
                          //     //           print('Pressed');
                          //     //         },
                          //     //       ),
                          //     //     )
                          //     //   ],
                          //     // ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
