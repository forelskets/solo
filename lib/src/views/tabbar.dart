import 'package:flutter/material.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/models/signin_model.dart';
import 'package:vendue_vendor/src/views/bookings.dart';
import 'package:vendue_vendor/src/views/home.dart';
import 'package:vendue_vendor/src/views/productList.dart';
import 'package:vendue_vendor/src/views/profile.dart';
import 'package:vendue_vendor/src/views/serviceList.dart';

// ignore: must_be_immutable
class TabbarScreen extends StatefulWidget {
  int currentIndex=0;
  TabbarScreen({this.currentIndex});

  @override
  _TabbarScreenState createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen> {
  // int _currentIndex = 0;
  SigninModel signinModel;

  List<dynamic> _handlePages = [
    HomeScreen(),
    ServiceList(),
    ProductList(),
    BookingList(),
    // FireChatList(),
    ProfileScreen(),
  ];

  // ignore: unused_field

  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _handlePages[widget.currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          topLeft: Radius.circular(0),
        ),
        child: BottomNavigationBar(
          // iconSize: 28,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: appColorYellow,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          // unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          currentIndex: widget.currentIndex,
          onTap: (index) {
            setState(() {
              widget.currentIndex = index;
            });
          },
          // items: <BottomNavigationBarItem>[
          //   widget.currentIndex == 0
          //       ? BottomNavigationBarItem(
          //           icon: Icon(
          //             CupertinoIcons.house_fill,
          //             size: 28,
          //           ),
          //           // ignore: deprecated_member_use
          //           title: Text(
          //             "Home",
          //             style: TextStyle(color: appColorYellow),
          //           ))
          //       : BottomNavigationBarItem(
          //           icon: Icon(
          //             CupertinoIcons.house,
          //             size: 28,
          //           ),
          //           // ignore: deprecated_member_use
          //           title: Text(
          //             "Home",
          //             style: TextStyle(color: Colors.black),
          //           )),
          //   widget.currentIndex == 1
          //       ? BottomNavigationBarItem(
          //           icon: Icon(
          //             CupertinoIcons.bag_fill_badge_plus,
          //             size: 28,
          //           ),

          //           // ignore: deprecated_member_use
          //           title: Text(
          //             "Service",
          //             style: TextStyle(color: appColorYellow),
          //           ))
          //       : BottomNavigationBarItem(
          //           icon: Icon(
          //             CupertinoIcons.bag_badge_plus,
          //             size: 28,
          //           ),
          //           // ignore: deprecated_member_use
          //           title: Text(
          //             "Service",
          //             style: TextStyle(color: Colors.black),
          //           )),
          //   widget.currentIndex == 2
          //       ? BottomNavigationBarItem(
          //           icon: Icon(
          //             CupertinoIcons.cart,
          //             size: 28,
          //           ),

          //           // ignore: deprecated_member_use
          //           title: Text(
          //             "Product",
          //             style: TextStyle(color: appColorYellow),
          //           ))
          //       : BottomNavigationBarItem(
          //           icon: Icon(
          //             CupertinoIcons.cart,
          //             size: 28,
          //           ),
          //           // ignore: deprecated_member_use
          //           title: Text(
          //             "Product",
          //             style: TextStyle(color: Colors.black),
          //           )),
          //   widget.currentIndex == 3
          //       ? BottomNavigationBarItem(
          //           icon: Icon(
          //             CupertinoIcons.chat_bubble_text_fill,
          //             size: 28,
          //           ),

          //           // ignore: deprecated_member_use
          //           title: Text(
          //             "Message",
          //             style: TextStyle(color: appColorYellow),
          //           ))
          //       : BottomNavigationBarItem(
          //           icon: Icon(
          //             CupertinoIcons.chat_bubble_text,
          //             size: 28,
          //           ),

          //           // ignore: deprecated_member_use
          //           title: Text(
          //             "Message",
          //             style: TextStyle(color: Colors.black),
          //           )),
          //   widget.currentIndex == 4
          //       ? BottomNavigationBarItem(
          //           icon: Icon(
          //             CupertinoIcons.person_fill,
          //             size: 28,
          //           ),

          //           // ignore: deprecated_member_use
          //           title: Text(
          //             "Profile",
          //             style: TextStyle(color: appColorYellow),
          //           ))
          //       : BottomNavigationBarItem(
          //           icon: Icon(
          //             CupertinoIcons.person,
          //             size: 28,
          //           ),

          //           // ignore: deprecated_member_use
          //           title: Text(
          //             "Profile",
          //             style: TextStyle(color: Colors.black),
          //           )),
          // ],
          items: <BottomNavigationBarItem>[
            widget.currentIndex == 0
                ? BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/home2.png',
                      height: 25,
                      color: appColorGreen,
                    ),
                    label: "Home")
                : BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/home.png',
                      height: 25,
                    ),
                    label: "Home"),
            widget.currentIndex == 1
                ? BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/service2.png',
                      height: 25,
                      color: appColorGreen,
                    ),
                    label: "Services")
                : BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/service1.png',
                      height: 25,
                    ),
                    label: "Services"),
            widget.currentIndex == 2
                ? BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/store2.png',
                      height: 25,
                      color: appColorGreen,
                    ),
                    label: "Product")
                : BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/store.png',
                      height: 25,
                    ),
                    label: "Product"),
            widget.currentIndex == 3
                ? BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/order2.png',
                      height: 25,
                      color: appColorGreen,
                    ),
                    label: "Bookings")
                : BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/order.png',
                      height: 25,
                    ),
                    label: "Bookings"),
            widget.currentIndex == 4
                ? BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/profile2.png',
                      height: 25,
                      color: appColorGreen,
                    ),
                    label: "Profile")
                : BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/profile.png',
                      height: 25,
                    ),
                    label: "Profile"),
          ],
        ),
      ),
    );
  }
}
