import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/models/get_service_model.dart';
import 'package:vendue_vendor/src/views/addService.dart';
import 'package:http/http.dart' as http;
import 'package:vendue_vendor/src/views/editService.dart';

class ServiceList extends StatefulWidget {
  @override
  _DealListScreenState createState() => _DealListScreenState();
}

class _DealListScreenState extends State<ServiceList> {
  // ignore: unused_field
  double _height, _width, _fixedPadding;
  GetServiceModal getServiceModal;
  bool isLoading = false;
  bool likePressed = false;

  @override
  void initState() {
    // getLoc();
    _getProducts();

    super.initState();
  }

  refresh() {
    _getProducts();
  }

  _getProducts() async {
    if (mounted)
      setState(() {
        isLoading = true;
      });

    var uri = Uri.parse('${baseUrl()}/get_vendor_service');
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
    getServiceModal = GetServiceModal.fromJson(userData);
    print("+++++++++");
    print(responseData);
    print("+++++++++");

    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.015;

    return Scaffold(
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
          "Service",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(CupertinoIcons.add_circled),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddService(refresh: refresh)),
                );
              })
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(appColorYellow),
              ),
            )
          : Stack(
              alignment: Alignment.center,
              children: <Widget>[
                getServiceModal != null ? _homeList() : Container()
              ],
            ),
    );
  }

  // Widget _body(BuildContext context) {
  //   return _homeList();
  // }

  Widget _homeList() {
    return AnimationLimiter(
        child: getServiceModal.data.length > 0
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: getServiceModal.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 100.0,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child:
                              _dealCard(context, getServiceModal.data[index])),
                    ),
                  );
                },
              )
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset(
                      "assets/images/noservice.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    "Service list empty!",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              )));
  }

  Widget _dealCard(BuildContext context, Data deal) {
    double _height, _width, _fixedPadding;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.015;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditService(service: deal)),
        );
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
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: _width * 2.5 / 10,
                                  height: _height * 1 / 10,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: FittedBox(
                                      child: CachedNetworkImage(
                                        imageUrl: deal.serviceImage != ""
                                            ? deal.serviceImage
                                            : null,
                                        placeholder: (context, url) => Center(
                                          child: Container(
                                            margin: EdgeInsets.all(70.0),
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
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
                                SizedBox(
                                  width: _width * 0.020,
                                ),
                                Flexible(
                                  // flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(deal.serviceName,
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontFamily: 'harabaraBold',
                                                fontSize: _width * 0.040,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 0),
                                        child: Text(
                                            "Store Name : ${deal.storeName}",
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'harabaraBold',
                                                color: Colors.black)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 0),
                                        child: Text(
                                            "Category : ${deal.categotyName}",
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'harabaraBold',
                                                color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: appColorYellow),
                                child: IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditService(service: deal)),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: appColorWhite,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _width * 0.025,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: _height * 0.005,
                          ),
                          _priceCard(deal),
                          SizedBox(
                            height: _height * 0.005,
                          ),
                          _dateTimeCard(deal),
                          // Card(
                          //   child: deal.lat != "" &&
                          //           deal.lon != "" &&
                          //           currentLocation != null
                          //       ? Padding(
                          //           padding: EdgeInsets.symmetric(
                          //               vertical: 10, horizontal: 10),
                          //           child: Column(
                          //             children: [
                          //               SizedBox(
                          //                 height: _height * 0.005,
                          //               ),
                          //               Row(
                          //                 children: [
                          //                   Icon(
                          //                     CupertinoIcons.map_pin,
                          //                     size: _width * 0.050,
                          //                   ),
                          //                   Text(
                          //                       calculateDistance(
                          //                                   currentLocation
                          //                                       .latitude,
                          //                                   currentLocation
                          //                                       .longitude,
                          //                                   double.parse(
                          //                                       deal.lat),
                          //                                   double.parse(
                          //                                       deal.lon))
                          //                               .toStringAsFixed(0) +
                          //                           "km",
                          //                       textAlign: TextAlign.start,
                          //                       overflow: TextOverflow.ellipsis,
                          //                       maxLines: 2,
                          //                       style: TextStyle(
                          //                           fontSize: 14,
                          //                           fontWeight: FontWeight.bold,
                          //                           color: Colors.black)),
                          //                 ],
                          //               ),
                          //               SizedBox(
                          //                 height: _height * 0.005,
                          //               ),
                          //             ],
                          //           ),
                          //         )
                          //       : Container(),
                          // ),
                          SizedBox(
                            height: _height * 0.010,
                          ),
                        ],
                      ),
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

  Widget _priceCard(Data deal) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.ticket,
                        size: _width * 0.050,
                      ),
                      SizedBox(
                        width: _width * 0.010,
                      ),
                      Flexible(
                        child: Text("Price : \$${deal.servicePrice}",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: _width * 0.030,
                                fontFamily: 'harabaraBold',
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.tickets,
                        size: _width * 0.050,
                      ),
                      SizedBox(
                        width: _width * 0.010,
                      ),
                      Flexible(
                        child: Text("Price Unit: ${deal.priceUnit}",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontFamily: 'harabaraBold',
                                fontSize: _width * 0.030,
                                color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateTimeCard(Data deal) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.clock_fill,
                        size: _width * 0.050,
                      ),
                      SizedBox(
                        width: _width * 0.010,
                      ),
                      Flexible(
                        child: Text("Duration : ${deal.duration} Hour",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: _width * 0.030,
                                fontFamily: 'harabaraBold',
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: _width * 0.050,
                      ),
                      SizedBox(
                        width: _width * 0.010,
                      ),
                      Flexible(
                        child: Text("Ratings : ",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontFamily: 'harabaraBold',
                                fontSize: _width * 0.030,
                                color: Colors.black)),
                      ),
                      RatingBar.builder(
                        initialRating: deal.serviceRatings != ""
                            ? double.parse(deal.serviceRatings)
                            : 0.0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        ignoreGestures: true,
                        itemSize: _width * 0.30 / 10,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
