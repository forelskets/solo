import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/models/transaction_model.dart';
import 'package:vendue_vendor/src/views/walletorderdetials.dart';

class Wallet extends StatefulWidget {
  final Color cardBackgroundColor = Colors.white;

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  double _height, _width, _fixedPadding;
  bool isLoading = false;
  TransactionModel transactionModel;

  refresh() {
    _getOrder();
  }

  @override
  void initState() {
    _getOrder();
    super.initState();
  }

  _getOrder() async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}/latest_transaction');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['v_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    transactionModel = TransactionModel.fromJson(userData);

    print(responseData);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.020;
    return Scaffold(
      // drawer: Drawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[_getBody()],
          ),
        ],
      ),
    );
  }

  // Widget _appbar() {
  //   return SliverAppBar(
  //     backgroundColor: appColorGreen,
  //     primary: true,
  //     pinned: true,
  //     centerTitle: true,
  //     expandedHeight: 200,
  //     automaticallyImplyLeading: false,
  //     title: SABT(child: Text("Dashboard")),
  //     flexibleSpace: FlexibleSpaceBar(
  //       background: Container(
  //         decoration: BoxDecoration(
  //             image: DecorationImage(
  //                 image: AssetImage("assets/images/3659193.jpg"),
  //                 fit: BoxFit.cover)),
  //       ),
  //     ),
  //   );
  // }

  Widget _getBody() => SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(_fixedPadding),
          child: Container(
              // color: Colors.white,

              width: _width,
              child: _getColumnBody()),
        ),
      );

  Widget _getColumnBody() => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _vendorDetails(),
          // SizedBox(
          //   height: _height * 0.025,
          // ),
          // _earningWidget(),
          SizedBox(
            height: _height * 0.025,
          ),
          _orders()
        ],
      );

  // Widget _earningWidget() {
  //   return Container(
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Container(
  //             height: _height * 1.5 / 10,
  //             child: Container(
  //               decoration: BoxDecoration(
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.grey.withOpacity(0.5),
  //                       spreadRadius: 0,
  //                       blurRadius: 5,
  //                       // offset: Offset(0, 0), // changes position of shadow
  //                     ),
  //                   ],
  //                   borderRadius: BorderRadius.circular(10),
  //                   gradient: LinearGradient(
  //                       begin: Alignment.topLeft,
  //                       end: Alignment.bottomRight,
  //                       stops: [
  //                         0.0,
  //                         0.3,
  //                         0.7,
  //                         1
  //                       ],
  //                       colors: [
  //                         Color(0xFF00EEFC),
  //                         Color(0xFF5C9EF4),
  //                         Color(0xFFC835E2),
  //                         Color(0xFFF67378),
  //                       ])),
  //               child: Padding(
  //                 padding: EdgeInsets.all(_fixedPadding),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         SizedBox(
  //                           width: _width * 0.005,
  //                         ),
  //                         Text(
  //                           'Earnings',
  //                           style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: _width * 0.040,
  //                               fontWeight: FontWeight.w700),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: _height * 0.005,
  //                     ),
  //                     Text(
  //                       transactionModel != null ? transactionModel.earnings : "",
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: _width * 0.055,
  //                           fontWeight: FontWeight.w700),
  //                     ),
  //                     Icon(
  //                       Icons.trending_up,
  //                       color: Colors.white,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           width: _width * 0.020,
  //         ),
  //         Expanded(
  //           child: Container(
  //             height: _height * 1.5 / 10,
  //           ),
  //         ),
  //         // Expanded(
  //         //   child: Container(
  //         //     height: _height * 1.5 / 10,
  //         //     child: Container(
  //         //       decoration: BoxDecoration(
  //         //         color: Colors.white,
  //         //         boxShadow: [
  //         //           BoxShadow(
  //         //             color: Colors.grey.withOpacity(0.5),
  //         //             spreadRadius: 0,
  //         //             blurRadius: 5,
  //         //             // offset: Offset(0, 0), // changes position of shadow
  //         //           ),
  //         //         ],
  //         //         borderRadius: BorderRadius.circular(10),
  //         //       ),
  //         //       child: Padding(
  //         //         padding: EdgeInsets.all(_fixedPadding),
  //         //         child: Column(
  //         //           crossAxisAlignment: CrossAxisAlignment.start,
  //         //           mainAxisAlignment: MainAxisAlignment.center,
  //         //           children: [
  //         //             Row(
  //         //               children: [
  //         //                 SizedBox(
  //         //                   width: _width * 0.005,
  //         //                 ),
  //         //                 Text(
  //         //                   'Gross Sales',
  //         //                   style: TextStyle(
  //         //                       color: Colors.black,
  //         //                       fontSize: _width * 0.040,
  //         //                       fontWeight: FontWeight.w700),
  //         //                 ),
  //         //               ],
  //         //             ),
  //         //             SizedBox(
  //         //               height: _height * 0.005,
  //         //             ),
  //         //             Text(
  //         //               '15222.00',
  //         //               style: TextStyle(
  //         //                   color: Colors.black,
  //         //                   fontSize: _width * 0.055,
  //         //                   fontWeight: FontWeight.w700),
  //         //             ),
  //         //             Icon(
  //         //               Icons.trending_up,
  //         //               color: Colors.black,
  //         //             ),
  //         //           ],
  //         //         ),
  //         //       ),
  //         //     ),
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  Widget _orders() {
    return Container(
      width: _width,
      // height: _height * 5 / 10,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 5,
            // offset: Offset(0, 0), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(_height * 0.030),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Latest Transactions',
                  style: GoogleFonts.lato(
                      fontSize: _width * 0.045, fontWeight: FontWeight.bold),
                ),
                // Text(
                //   'Pending',
                //   style: GoogleFonts.lato(
                //     fontSize: _width * 0.030,
                //   ),
                // ),
                // TextButton(
                //   onPressed: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => VendorOrders()),
                //   ),
                //   child: Text(
                //     'See all',
                //     style: GoogleFonts.lato(
                //         decoration: TextDecoration.underline,
                //         fontSize: _width * 0.030,
                //         fontWeight: FontWeight.bold),
                //   ),
                // )
              ],
            ),
            SizedBox(
              height: _height * 0.015,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'Order No.',
            //       style: GoogleFonts.lato(
            //           color: Colors.blue,
            //           fontSize: _width * 0.035,
            //           fontWeight: FontWeight.bold),
            //     ),
            //     Text(
            //       'Status',
            //       style: GoogleFonts.lato(
            //           color: Colors.blue,
            //           fontSize: _width * 0.035,
            //           fontWeight: FontWeight.bold),
            //     ),
            //     Text(
            //       'Earnings',
            //       style: GoogleFonts.lato(
            //           color: Colors.blue,
            //           fontSize: _width * 0.035,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: _height * 0.015,
            // ),
            isLoading == true
                ? Container(
                    height: 20,
                    width: 20,
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 1,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.black),
                    )))
                : transactionModel != null
                    ? transactionModel.payment != null
                        ? ListView.separated(
                            padding: EdgeInsets.all(0),
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: transactionModel.payment.length,
                            // itemCount: transactionModel.payment.length <= 10
                            //     ? transactionModel.orders.length
                            //     : 10,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VendorOrderDetail(
                                                  orders: transactionModel
                                                      .payment[index],
                                                  refresh: refresh)),
                                    );
                                  },
                                  child: _dummyLoader(
                                      transactionModel.payment[index]));
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                          )
                        : Center(
                            child: Text("No orders found"),
                          )
                    : Center(
                        child: Text("No orders found"),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _dummyLoader(Payment orders) {
    return Column(
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            orders.profilePic != ""
                ? CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(orders.profilePic),
                    backgroundColor: Colors.transparent,
                  )
                : CircleAvatar(
                    radius: 25.0,
                    backgroundImage: AssetImage(
                      "assets/images/user.png",
                    ),
                    backgroundColor: Colors.transparent,
                  ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (orders.status == 'pending')
                    Text(
                      '#${orders.status}',
                      style: GoogleFonts.lato(
                          fontSize: _width * 0.040,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  if (orders.status == 'process')
                    Text(
                      '#${orders.status}',
                      style: GoogleFonts.lato(
                          fontSize: _width * 0.040,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  if (orders.status == 'paid')
                    Text(
                      '#${orders.status}',
                      style: GoogleFonts.lato(
                          fontSize: _width * 0.040,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  SizedBox(height: 10),
                  Text(
                    orders.createdDate,
                    style: TextStyle(fontSize: _width * 0.025),
                  )
                ],
              ),
            ),
            Expanded(
              child: Text(
                '\$${orders.payment}',
                textAlign: TextAlign.end,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: _width * 0.035,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _vendorDetails() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Welcome ${transactionModel != null ? userName : ""}!',
            style: GoogleFonts.lato(
                fontSize: _width * 0.045, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
