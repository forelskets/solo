// ignore_for_file: unused_field, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendue_vendor/src/blocs/getbooking_bloc.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/models/booking_item_model.dart';
import 'package:http/http.dart' as http;
import 'package:vendue_vendor/src/views/bookings.dart';

// ignore: must_be_immutable
class BookingDetailScreen extends StatefulWidget {
  Booking data;
  BookingDetailScreen(this.data);

  @override
  State<StatefulWidget> createState() {
    return _BookingDetailScreenState(this.data);
  }
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool isLoading = false;
  var rateValue;
  TextEditingController _ratingcontroller = TextEditingController();

  _BookingDetailScreenState(Booking data);

  @override
  void initState() {
    super.initState();
  }

  apicallStatus(String id, String status) async {
    isLoading = true;
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['id'] = id;
      map['status'] = status;

      final response = await http.post(
          Uri.parse('${baseUrl()}booking_status_change_by_vendor'),
          headers: headers,
          body: map);

      var dic = json.decode(response.body);
      print(dic);
      print(map.entries);
      Map userMap = jsonDecode(response.body);
      if (dic['response_code'] != '0') {
        isLoading = false;
        print('successfully changed');
        Fluttertoast.showToast(
            msg: "Booking Status Change",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade200,
            textColor: Colors.black,
            fontSize: 13.0);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BookingList()));
        getBookingBloc.getBookingSink(userID, "Confirm");
      }
    } on Exception {
      // Toast.show("No Internet connection", context,
      //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Fluttertoast.showToast(
          msg: "No Internet connection",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey.shade200,
          textColor: Colors.black,
          fontSize: 13.0);
      isLoading = false;
      throw Exception('No Internet connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade200,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Booking Detail",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
            // height: //set your height here
            width: double.maxFinite, //set your width here
            decoration: BoxDecoration(
                // color: Colors.grey.shade200,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0))),
            child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: widget.data.status == 'On Way'
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                apicallStatus(widget.data.id, "Completed");
                              },
                              child: Flexible(
                                  child: Text(
                                "Complete",
                                style: TextStyle(color: appColorWhite),
                              )),
                              style: ElevatedButton.styleFrom(
                                  primary: appColorGreen,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  textStyle: TextStyle(fontSize: 15),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: appColorGreen, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                            ),
                          ),
                        ],
                      )
                    : widget.data.status == 'Confirm'
                        ? Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    apicallStatus(widget.data.id, "On Way");
                                  },
                                  child: Flexible(
                                      child: Text(
                                    "On Way",
                                    style: TextStyle(color: appColorGreen),
                                  )),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      textStyle: TextStyle(fontSize: 15),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: appColorGreen, width: 2),
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    apicallStatus(widget.data.id, "Cancel");
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: appColorWhite),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: appColorGreen,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      textStyle: TextStyle(fontSize: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                ),
                              ),
                            ],
                          )
                        : Text(''))),
      ),
      body: isLoading ? loader(context) : bodyData(),
    );
  }

  Widget bodyData() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                bookDetailCard(),
                bookcard(),
                datetimecard(),
                pricingcard()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bookDetailCard() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.service.serviceName,
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey.shade600,
                          ),
                          Flexible(
                              child: Text(
                            widget.data.address,
                            maxLines: 3,
                            style: TextStyle(fontSize: 11.0),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.blue.shade100,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  widget.data.slot,
                                  style: TextStyle(
                                      color: appColorGreen,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.data.date,
                                  style: TextStyle(
                                      color: appColorGreen,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget bookcard() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Booking Detail',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status',
                    ),
                    Container(
                      height: 30,
                      width: 80,
                      child: Center(
                        child: Text(
                          widget.data.status,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Status',
                    ),
                    Container(
                      height: 30,
                      width: 80,
                      child: Center(
                        child: Text(
                          widget.data.paymentStatus,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Mode',
                    ),
                    Container(
                      height: 30,
                      width: 80,
                      child: Center(
                        child: Text(
                          widget.data.paymentMode,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hint',
                    ),
                    Text(
                      widget.data.notes,
                    ),
                  ],
                )
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget datetimecard() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Booking Date & Time',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking At',
                    ),
                    Text(
                      widget.data.date + "\n" + widget.data.slot,
                    ),
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget pricingcard() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Booking Date & Time',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                    ),
                    Text(
                      "\$ " + widget.data.amount,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
