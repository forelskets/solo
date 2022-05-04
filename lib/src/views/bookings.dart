import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vendue_vendor/src/blocs/getbooking_bloc.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/models/booking_item_model.dart';
import 'package:vendue_vendor/src/views/BookingDeatil.dart';

// ignore: must_be_immutable
class BookingList extends StatefulWidget {
  bool back;
  BookingList({this.back});
  @override
  BookingListState createState() => BookingListState();
}

class BookingListState extends State<BookingList> {
  // BookingProvider provider;
  String activeValue = "Confirm";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(">>>>>>>>>>>>>>>>>>>>>>" + userID);
    getBookingBloc.getBookingSink(userID, activeValue.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/shield.jpg",
            height: 40,
          ),
        ),
        title: Text("Bookings",
            style: TextStyle(color: blackcolor, fontWeight: FontWeight.w600)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            color: appColorWhite,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              children: [
                InkWell(
                  onTap: () {
                    getBookingBloc.getBookingSink(userID, "Confirm");
                    setState(() {
                      activeValue = "Confirm";
                    });
                  },
                  child: Container(
                    width: 105,
                    alignment: Alignment.center,
                    child: Text("Confirm",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: activeValue == "Confirm"
                                ? Colors.white
                                : Colors.blue.shade900)),
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    decoration: BoxDecoration(
                      color:
                          activeValue == "Confirm" ? IndigoColor : Colors.white,
                      border: Border.all(
                          color: activeValue == "Confirm"
                              ? Colors.white
                              : Colors.blue.shade900),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getBookingBloc.getBookingSink(userID, "On Way");
                    setState(() {
                      activeValue = "On Way";
                    });
                  },
                  child: Container(
                    width: 105,
                    alignment: Alignment.center,
                    child: Text("On Way",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: activeValue == "On Way"
                                ? Colors.white
                                : IndigoColor)),
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    decoration: BoxDecoration(
                        color: activeValue == "On Way"
                            ? IndigoColor
                            : Colors.white,
                        border: Border.all(
                            color: activeValue == "On Way"
                                ? Colors.white
                                : Colors.blue.shade900),
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getBookingBloc.getBookingSink(userID, "Cancel");
                    setState(() {
                      activeValue = "Cancel";
                    });
                  },
                  child: Container(
                    width: 105,
                    alignment: Alignment.center,
                    child: Text("Cancelled",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: activeValue == "Cancel"
                                ? Colors.white
                                : IndigoColor)),
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    decoration: BoxDecoration(
                        color: activeValue == "Cancel"
                            ? IndigoColor
                            : Colors.white,
                        border: Border.all(
                            color: activeValue == "Cancel"
                                ? Colors.white
                                : Colors.blue.shade900),
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Completed");
                    // provider.GetBookings(orderstatus: "Completed");
                    getBookingBloc.getBookingSink(userID, "Completed");
                    setState(() {
                      activeValue = "Completed";
                    });
                  },
                  child: Container(
                    width: 105,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    alignment: Alignment.center,
                    child: Text("Completed",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: activeValue == "Completed"
                                ? Colors.white
                                : IndigoColor)),
                    decoration: BoxDecoration(
                        color: activeValue == "Completed"
                            ? IndigoColor
                            : Colors.white,
                        border: Border.all(
                            color: activeValue == "Completed"
                                ? Colors.white
                                : Colors.blue.shade900),
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<BookItemModel>(
                stream: getBookingBloc.getBookingStream,
                builder: (context, AsyncSnapshot<BookItemModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<Booking> allBooking = snapshot.data.booking != null
                      ? snapshot.data.booking
                      : [];
                  return allBooking.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: allBooking.length,
                          itemBuilder: (context, int index) {
                            return bookCard(allBooking[index]);
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
                                "assets/images/nobooking.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              "Booking list empty!",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ));
                }),
          )
        ],
      ),
    );
  }

  Widget bookCard(Booking data) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          color: Colors.grey.shade100,
          elevation: 1.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.service.serviceName,
                          style: TextStyle(
                              color: blackcolor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(data.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: blackcolor,
                                    fontWeight: FontWeight.normal)),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.date_range_outlined),
                          SizedBox(width: 4),
                          Text(data.date + ", " + data.slot,
                              style: TextStyle(
                                  color: blackcolor,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          children: [
                            Text("Pending Amount : " + "\$ " + data.amount,
                                style: TextStyle(
                                    color: IndigoColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14)),
                          ],
                        ),
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
                                // color: Colors.redAccent,
                              ),
                              child: data.service.serviceImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: data.service.serviceImage,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(appColorGreen),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                                child: Text('Image Not Found')),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container()),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              print(data);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookingDetailScreen(data)));
                            },
                            child: Container(
                              width: 80.0,
                              height: MediaQuery.of(context).size.height / 25,
                              alignment: Alignment.center,
                              child: Center(
                                  child: Text("More Info",
                                      style: TextStyle(
                                          color: WhiteColor, fontSize: 10))),
                              margin: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: IndigoColor,
                                border: Border.all(color: IndigoColor),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
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
}
