import 'package:flutter/material.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/models/transaction_model.dart';

// ignore: must_be_immutable
class VendorOrderDetail extends StatefulWidget {
  Color cardBackgroundColor = Colors.white;
  Payment orders;
  Function refresh;
  VendorOrderDetail({this.orders, this.refresh});

  @override
  _VendorOrderDetailState createState() =>
      _VendorOrderDetailState(refresh: refresh);
}

class _VendorOrderDetailState extends State<VendorOrderDetail> {
  Function refresh;
  _VendorOrderDetailState({this.refresh});
  double _height, _width, _fixedPadding;

  bool loader = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-get-phone");

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.020;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        title: Text(
          'Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.95),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: loader
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(appColorYellow),
                    ))
                  : CustomScrollView(
                      slivers: [
                        _getBody(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBody() => SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: _height * 0.10 / 10),
          child: Container(
            height: _height,
            child: Card(
              color: widget.cardBackgroundColor,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SizedBox(
                  child: Padding(
                padding: EdgeInsets.all(_fixedPadding),
                child: _getColumnBody(),
              )),
            ),
          ),
        ),
      );

  Widget _getColumnBody() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.orders.profilePic != ""
              ? Center(
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(widget.orders.profilePic),
                    backgroundColor: Colors.transparent,
                  ),
                )
              : Center(
                  child: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: AssetImage(
                      "assets/images/user.png",
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
          SizedBox(
            height: _height * 0.010,
          ),
          Center(
              child: Text(
            '#${widget.orders.status}',
            style: TextStyle(
                fontSize: _width * 0.045, fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: _height * 0.60 / 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Details of Transaction',
                style: TextStyle(
                    fontSize: _width * 0.040,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: _height * 0.15 / 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: TextStyle(
                    fontSize: _width * 0.040,
                    color: Colors.black45,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                '${widget.orders.status}',
                style: TextStyle(
                    fontSize: _width * 0.040,
                    color: appColorYellow,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: _height * 0.008,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaction ID',
                style: TextStyle(
                    fontSize: _width * 0.040,
                    color: Colors.black45,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                '#${widget.orders.id}',
                style: TextStyle(
                    fontSize: _width * 0.040,
                    color: appColorYellow,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: _height * 0.008,
          ),
          Text(
            widget.orders.createdDate,
            style: TextStyle(
                fontSize: _width * 0.030,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: _height * 0.030,
          ),
          Divider(),

          _taxAndTotal(),
          Divider(),
          SizedBox(
            height: _height * 0.050,
          ),
          // _buttonShow != false
          //     ? Center(
          //         child: Container(
          //           width: _width * 10 / 10,
          //           child: ElevatedButton(
          //             child: Text(
          //               'Update Status',
          //               style: TextStyle(
          //                   color: Colors.black,
          //                   fontSize: _width * 0.035,
          //                   fontWeight: FontWeight.bold),
          //             ),
          //             style: ElevatedButton.styleFrom(
          //               primary: appColorGreen,
          //               onPrimary: Colors.white,
          //               onSurface: Colors.grey,
          //             ),
          //             onPressed: () {
          //               _updateStatus();
          //             },
          //           ),
          //         ),
          //       )
          //     : Container()
        ],
      );

  Widget _taxAndTotal() => Column(
        children: [
          SizedBox(
            height: _height * 0.005,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Total',
                style: TextStyle(
                    fontSize: _width * 0.045,
                    color: Colors.black45,
                    fontWeight: FontWeight.w700),
              ),
              Text('\$${widget.orders.payment}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: _width * 0.040,
                  )),
            ],
          ),
        ],
      );

  // Widget _products() => Container(
  //         child: ListView.separated(
  //       padding: EdgeInsets.all(0),
  //       scrollDirection: Axis.vertical,
  //       physics: NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       itemCount: widget.orders.products.length,
  //       itemBuilder: (context, index) {
  //         return Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.all(Radius.circular(5)),
  //                   child: CachedNetworkImage(
  //                     height: 70,
  //                     width: 70,
  //                     fit: BoxFit.cover,
  //                     imageUrl: widget.orders.products[index].productImage,
  //                     placeholder: (context, url) => Image.asset(
  //                       'assets/images/loading.gif',
  //                       fit: BoxFit.cover,
  //                       height: 60,
  //                       width: 60,
  //                     ),
  //                     errorWidget: (context, url, error) => Icon(Icons.error),
  //                   ),
  //                 ),
  //                 SizedBox(width: 15),
  //                 Flexible(
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       Expanded(
  //                         child: Padding(
  //                           padding: const EdgeInsets.only(top: 10),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: <Widget>[
  //                               Text(widget.orders.products[index].productName,
  //                                   overflow: TextOverflow.ellipsis,
  //                                   maxLines: 2,
  //                                   style: TextStyle(
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.bold)),
  //                               Text(
  //                                 'Qty: ${widget.orders.products[index].qty}',
  //                                 overflow: TextOverflow.ellipsis,
  //                                 maxLines: 2,
  //                                 style: Theme.of(context).textTheme.caption,
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //             SizedBox(
  //               height: _height * 0.010,
  //             ),
  //             Container(
  //               alignment: Alignment.centerLeft,
  //               padding: EdgeInsets.only(left: 10),
  //               height: _height * 0.50 / 10,
  //               width: _width,
  //               decoration: BoxDecoration(
  //                   color: Colors.grey[100],
  //                   borderRadius: BorderRadius.circular(8)),
  //               child: RichText(
  //                 textAlign: TextAlign.start,
  //                 text: TextSpan(
  //                   text: 'Item total : ',
  //                   style: TextStyle(
  //                       fontSize: _width * 0.045,
  //                       color: appColorDeepGreen,
  //                       fontFamily: 'appFont',
  //                       fontWeight: FontWeight.w700),
  //                   children: <TextSpan>[
  //                     TextSpan(
  //                         text: '\$${widget.orders.products[index].price}',
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.normal,
  //                           fontFamily: 'appFont',
  //                           color: Colors.black,
  //                           fontSize: _width * 0.040,
  //                         )),
  //                   ],
  //                 ),
  //               ),
  //             )
  //           ],
  //         );
  //       },
  //       separatorBuilder: (context, index) {
  //         return Divider();
  //       },
  //     ));

  // void _bottmShit(BuildContext context) {
  //   final act = CupertinoActionSheet(
  //       // title: Text('Select Option'),
  //       // message: Text('Which option?'),
  //       actions: <Widget>[
  //         CupertinoActionSheetAction(
  //           child: Text(
  //             'Processing',
  //             style: TextStyle(color: Colors.blue, fontSize: _width * 0.040),
  //           ),
  //           onPressed: () {
  //             print('pressed');
  //             setState(() {
  //               _orderStatus = 'Processing';
  //             });
  //             Navigator.pop(context);
  //           },
  //         ),
  //         CupertinoActionSheetAction(
  //           child: Text(
  //             'Dispatch',
  //             style: TextStyle(color: Colors.blue, fontSize: _width * 0.040),
  //           ),
  //           onPressed: () {
  //             print('pressed');
  //             setState(() {
  //               _orderStatus = 'Dispatch';
  //             });
  //             Navigator.pop(context);
  //           },
  //         ),
  //         CupertinoActionSheetAction(
  //           child: Text(
  //             'Deliver',
  //             style: TextStyle(color: Colors.blue, fontSize: _width * 0.040),
  //           ),
  //           onPressed: () {
  //             print('pressed');
  //             setState(() {
  //               _orderStatus = 'Deliver';
  //             });
  //             Navigator.pop(context);
  //           },
  //         )
  //       ],
  //       cancelButton: CupertinoActionSheetAction(
  //         child: Text(
  //           'Cancel',
  //           style: TextStyle(color: Colors.red),
  //         ),
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //       ));
  //   showCupertinoModalPopup(
  //       context: context, builder: (BuildContext context) => act);
  // }

}
