import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/models/details_model.dart';
import 'package:http/http.dart' as http;

class ReviewScreen extends StatefulWidget {
  final String productId;
  ReviewScreen({this.productId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState(productId: productId);
}

class _ReviewScreenState extends State<ReviewScreen> {
  final String productId;
  _ReviewScreenState({this.productId});
  double _height, _width;

  DetialsModel detialsModel;

  bool isLoading = false;

  @override
  void initState() {
    _getDetails();
    // _getCat();

    super.initState();
  }

  _getDetails() async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}/get_res_details');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['res_id'] = productId;
    request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    detialsModel = DetialsModel.fromJson(userData);

    if (detialsModel.status == 1) {}

    setState(() {
      isLoading = false;
    });

    print(responseData);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Reviews',
          style:
              TextStyle(fontFamily: 'harabaraBold', fontSize: _width * 0.045),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(appColorYellow),
                  ),
                )
              : _homeList()
        ],
      ),
    );
  }

  // Widget _body(BuildContext context) {
  //   return _homeList();
  // }

  Widget _homeList() {
    return Column(
      children: [
        Container(
          width: _width * 4 / 10,
          height: _height * 1 / 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40), color: Colors.black),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  detialsModel.restaurant.resRatings != ""
                      ? detialsModel.restaurant.resRatings
                      : "0.0",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      fontFamily: 'harabaraBold',
                      fontSize: _width * 0.050,
                      // fontWeight: FontWeight.bold,
                      color: Colors.amber)),
              SizedBox(height: _height * 0.005),
              RatingBar.builder(
                initialRating: detialsModel.restaurant.resRatings != ""
                    ? double.parse(detialsModel.restaurant.resRatings)
                    : 0.0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                unratedColor: Colors.grey,
                itemCount: 5,
                itemSize: _height * 0.020,
                // itemPadding: EdgeInsets.symmetric(
                //     horizontal: 4.0),
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
        SizedBox(
          height: _height * 0.010,
        ),
        Expanded(
          child: AnimationLimiter(
              child: detialsModel != null
                  ? detialsModel.review.length > 0
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: detialsModel.review.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                horizontalOffset: 100.0,
                                child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    child: _nearByitemCard(
                                        context, detialsModel.review[index])),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'No review found!',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: _width * 0.035),
                          ),
                        )
                  : Container()),
        ),
      ],
    );
  }

  Widget _nearByitemCard(BuildContext context, Review review) {
    final f = new DateFormat('dd-MM-yyyy hh:mm');
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          review.revUserData.profilePic != ""
                              ? CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: NetworkImage(
                                      review.revUserData.profilePic),
                                  backgroundColor: Colors.transparent,
                                )
                              : CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage:
                                      AssetImage('assets/images/user.png'),
                                  backgroundColor: Colors.transparent,
                                ),
                          SizedBox(
                            width: _width * 0.015,
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(review.revUserData.username,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontFamily: 'harabaraBold',
                                            fontSize: _width * 0.040,
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Text(
                                      f.format(new DateTime
                                              .fromMillisecondsSinceEpoch(
                                          int.parse(review.revDate) * 1000)),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: _width * 0.022,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: _height * 0.005,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        children: [
                                          RatingBar.builder(
                                            initialRating: review.revStars != ""
                                                ? double.parse(review.revStars)
                                                : 0.0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemSize: _height * 0.015,
                                            // itemPadding: EdgeInsets.symmetric(
                                            //     horizontal: 4.0),
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
                                SizedBox(
                                  height: _height * 0.005,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        child: Flexible(
                                      child: Column(
                                        children: [
                                          Text(
                                            review.revText,
                                            style: TextStyle(
                                                fontSize: _width * 0.030),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _width * 0.025,
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
}
