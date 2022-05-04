import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/models/payments_model.dart';
import 'package:http/http.dart' as http;

class PaymentList extends StatefulWidget {
  final String appName = "Awesome app";

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  double _height, _width, _fixedPadding;

  @override
  void initState() {
    _getProducts();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool loader = false;
  PaymentsModel paymentsModel;

  _getProducts() async {
    if (mounted)
      setState(() {
        loader = true;
      });

    var uri = Uri.parse('${baseUrl()}/vendor_payment');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    // request.fields.addAll({'user_id': userID});
    request.fields['v_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    paymentsModel = PaymentsModel.fromJson(userData);
    print("+++++++++");
    print(responseData);
    print("+++++++++");

    if (mounted)
      setState(() {
        loader = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.015;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Orders',
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: loader
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(appColorYellow),
              ),
            )
          : SingleChildScrollView(
              child: paymentsModel != null ? _getColumnBody() : Container()),
    );
  }

  Widget _getColumnBody() => Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(_fixedPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Earnings",
                  style: TextStyle(
                    fontSize: _width * 0.040,
                  ),
                ),
                Text(
                  "\$${paymentsModel.totalEarning}",
                  style: TextStyle(
                      fontSize: _width * 0.040, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Divider(),
          AnimationLimiter(
              child: paymentsModel.payment.length > 0
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: paymentsModel.payment.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            horizontalOffset: 100.0,
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: _dealCard(
                                    context, paymentsModel.payment[index])),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                      'Payment list empty!',
                      style: TextStyle(
                          fontSize: _width * 0.035,
                          fontWeight: FontWeight.bold),
                    ))),
        ],
      );

  Widget _dealCard(BuildContext context, Payment payment) {
    return InkWell(
      onTap: () {},
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.info),
                                SizedBox(
                                  width: 05,
                                ),
                                Flexible(
                                  child: Column(
                                    children: [
                                      Text("Payment success",
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
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Column(
                                    children: [
                                      Text(
                                        "\$${payment.payment}",
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontFamily: 'harabaraBold',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: _width * 0.040,
                                        ),
                                      ),
                                    ],
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   height: _height * 0.025,
                          // ),
                          Text("Deal Name : ${payment.dealName}",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          SizedBox(
                            height: _height * 0.005,
                          ),
                          payment.txnId != ""
                              ? Text("Transaction ID: \$${payment.txnId}",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black))
                              : Container(),
                          SizedBox(
                            height: _height * 0.005,
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
                                    Text("Date : ${payment.pDate}",
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
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
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: _width * 2 / 10,
                          //       height: _height * 0.35 / 10,
                          //       child: ElevatedButton(
                          //         child: Text(
                          //           '',
                          //           style: TextStyle(
                          //               fontFamily: 'harabaraBold',
                          //               color: Colors.white),
                          //         ),
                          //         style: ElevatedButton.styleFrom(
                          //           primary: Colors.green,
                          //         ),
                          //         onPressed: () {
                          //           print('Pressed');
                          //         },
                          //       ),
                          //     ),
                          //   ],
                          // ),
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
