import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';
import 'package:vendue_vendor/src/global/global.dart';
import 'package:vendue_vendor/src/views/chat/color_utils.dart';
import 'package:vendue_vendor/src/views/chat/fireChat.dart';

class FireChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<FireChatList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          "Messages",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        friendListToMessage(userID),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget friendListToMessage(String userData) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chatList")
          .doc(userData)
          .collection(userData)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: snapshot.data.docs.length > 0
                ? ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, int index) {
                      List chatList = snapshot.data.docs;
                      return buildItem(chatList, index);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Padding(
                      padding: const EdgeInsets.only(left: 90),
                      child: const Divider(),
                    ),
                  )
                : Center(
                    child: Text("Currently you don't have any messages"),
                  ),
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CupertinoActivityIndicator(),
              ]),
        );
      },
    );
  }

  Widget buildItem(List chatList, int index) {
    return GestureDetector(
      onTap: () {
        print(userImg);
        print(userName);
        print(userID);
        print(chatList[index]['name']);
        print(chatList[index]['id']);
        print(chatList[index]['profileImage']);
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => FireChat(
                    // peerName:peerName,
                    // peerUrl:peerUrl,
                    currentuser: userID,
                    currentusername: userName,
                    currentuserimage: userImg,
                    peerID: chatList[index]['id'],
                    peerUrl: chatList[index]['profileImage'],
                    // userData: userData,
                    peerName: chatList[index]['name'])));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 2),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 0),
              child: Stack(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 30),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 50, top: 0, right: 40, bottom: 0),
                          child: Container(
                            // color: Colors.purple,
                            width: MediaQuery.of(context).size.width - 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 5,
                                ),
                                Container(
                                  // color: Colors.yellow,
                                  width:
                                      MediaQuery.of(context).size.width - 180,
                                  child: Text(
                                    chatList[index]['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Container(
                                    // color: Colors.red,
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    height: 20,
                                    child: Text(
                                      chatList[index]['content'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 10),
                      //   child: int.parse(chatList[index]['badge']) > 0
                      //       ? Container(
                      //           decoration: BoxDecoration(
                      //             shape: BoxShape.circle,
                      //             color: Colors.red,
                      //           ),
                      //           alignment: Alignment.center,
                      //           height: 30,
                      //           width: 30,
                      //           child: Text(
                      //             chatList[index]['badge'],
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w900),
                      //           ),
                      //         )
                      //       : Container(
                      //           child: Icon(
                      //             Icons.arrow_forward_ios,
                      //             color: appColorYellow,
                      //             size: 25.0,
                      //           ),
                      //         ),
                      // ),
                      Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Container(
                                  child: Text(
                                    format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(
                                            chatList[index]['timestamp'],
                                          ),
                                        ),
                                        locale: 'en_short'),
                                    style: TextStyle(
                                        color: HexColor("#343e57"),
                                        fontSize: 11.0,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                              int.parse(chatList[index]['badge']) > 0
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                          alignment: Alignment.center,
                                          height: 20,
                                          width: 20,
                                          child: Text(
                                            chatList[index]['badge'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 0),
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                  ),
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Material(
                  child: chatList[index]['profileImage'] != null
                      ? CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CupertinoActivityIndicator(),
                            width: 20.0,
                            height: 20.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          errorWidget: (context, url, error) => Material(
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          imageUrl: chatList[index]['profileImage'],
                          width: 20.0,
                          height: 20.0,
                          fit: BoxFit.cover,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.person,
                            size: 25,
                          ),
                        ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget friendName(AsyncSnapshot friendListSnapshot, int index) {
    return Container(
      width: 200,
      alignment: Alignment.topLeft,
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text:
                "${friendListSnapshot.data["firstname"]} ${friendListSnapshot.data["lastname"]}",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          )
        ]),
      ),
    );
  }

  Widget messageButton(AsyncSnapshot friendListSnapshot, int index) {
    // ignore: deprecated_member_use
    return RaisedButton(
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Text(
        "Message",
        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
      ),
      onPressed: () {},
    );
  }
}
