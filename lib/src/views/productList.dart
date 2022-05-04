import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/models/getProductModel.dart';
import 'package:http/http.dart' as http;
import 'package:vendue_vendor/src/views/add_product.dart';

class ProductList extends StatefulWidget {
  @override
  _DealListScreenState createState() => _DealListScreenState();
}

class _DealListScreenState extends State<ProductList> {
  // ignore: unused_field
  double _height, _width, _fixedPadding;
  GetProductModel getProductModel;
  bool isLoading = false;
  bool likePressed = false;
  bool editProduct = false;

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

    var uri = Uri.parse('${baseUrl()}/get_products_by_vendor_id');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    // request.fields.addAll({'user_id': userID});
    request.fields['vendor_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    getProductModel = GetProductModel.fromJson(userData);
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
          "Products",
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
                      builder: (context) =>
                          AddProductPage(refresh: refresh, editProduct: false)),
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
                getProductModel != null ? _homeList() : Container()
              ],
            ),
    );
  }

  // Widget _body(BuildContext context) {
  //   return _homeList();
  // }

  Widget _homeList() {
    return AnimationLimiter(
        child: getProductModel.products.length > 0
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: getProductModel.products.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 100.0,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: _dealCard(
                              context, getProductModel.products[index])),
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
                      "assets/images/noproducts.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    "Product list empty!",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              )));
  }

  Widget _dealCard(BuildContext context, Products deal) {
    double _height, _width, _fixedPadding;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.015;

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
                                        imageUrl: deal.productImage[0],
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
                                        child: Text(deal.productName,
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
                                        child: Text(deal.productDescription,
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
                                                AddProductPage(
                                                    refresh: refresh,
                                                    products: deal,
                                                    editProduct: true)),
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

  Widget _priceCard(Products deal) {
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
                        child: Text("Price : \$${deal.productPrice}",
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
                        initialRating: deal.proRatings != ""
                            ? double.parse(deal.proRatings)
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
