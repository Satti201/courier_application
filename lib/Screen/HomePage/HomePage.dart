import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:courier_application/Provider/SignInProvider.dart';
import 'package:courier_application/Provider/UploadIdProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../EditField/Colors.dart';
import '../../Models/AllUserData.dart';
import '../../Provider/ParcelProvider.dart';
import '../../Widgets/DrawerSide.dart';
import '../Login/LoginScreen.dart';
import '../Parcel/AddParcel.dart';
import '../Parcel/Parcel.dart';
import '../UploadId/UploadId.dart';

enum Page { dashboard, manage }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  late ParcelProvider parcelProvider;
  late int Length;
  List<AllUserData> UserDataLists = [];
  bool check = false;
  bool dataCheck = false;
  bool statusCheck = false;
  bool timeCheck = false;
  late int haveData;
  late int haveStatus;
  late String haveExpTime;

  @override
  Widget build(BuildContext context) {
    parcelProvider = Provider.of(context);
    parcelProvider.getParcelData();

    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm Logout"),
                content: const Text("Are you sure you want to Logout?"),
                actions: <Widget>[
                  FlatButton(
                    child: const Text("YES"),
                    onPressed: () {
                      Get.to(() => SignIn());
                    },
                  ),
                  FlatButton(
                    child: const Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        return Future.value(true);
      },
      child: Scaffold(
          drawer: DrawerSide(),
          appBar: AppBar(
            backgroundColor: scaffoldbackgroundColor,
            iconTheme: IconThemeData(color: textColor),
            title: const Text(
              "HomePage",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: _loadScreen()),
    );
  }

  Widget _loadScreen() {
    UploadIdProvider uploadIdProvider = Provider.of(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    right: 12, top: 22, bottom: 22, left: 11),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Parcel()));
                  },
                  child: Card(
                    child: ListTile(
                        title: FlatButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.people_outline),
                            label: const Text("Parcels")),
                        subtitle: Text(
                          '${parcelProvider.getReviewCartData.length}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 40.0),
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 22, bottom: 22),
                child: GestureDetector(
                  onTap: () async {
                    if (check == false) {
                      List<AllUserData> newList = [];
                      QuerySnapshot snapshot = await FirebaseFirestore.instance
                          .collection("UserData")
                          .get();
                      for (var element in snapshot.docs) {
                        AllUserData parcelData = AllUserData(
                          element.get("UserId"),
                          element.get("Username"),
                          element.get("email"),
                          element.get('password'),
                          element.get("PhoneNo"),
                        );

                        newList.add(parcelData);
                      }
                      UserDataLists = newList;
                      check = true;
                    }
                    if (check == true) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddParcel(UserDataLists)));
                    }
                  },
                  child: Card(
                    child: ListTile(
                        title: FlatButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.add),
                            label: const Text("Parcel")),
                        subtitle: Text(
                          '0',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 40.0),
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 12, top: 22, bottom: 22, left: 11),
                child: InkWell(
                  onTap: () async {
                    if (dataCheck == false) {
                      var collection =
                          FirebaseFirestore.instance.collection('UserUploadId');
                      var querySnapshot = await collection.get();
                      for (var queryDocumentSnapshot in querySnapshot.docs) {
                        Map<String, dynamic> data =
                            queryDocumentSnapshot.data();
                        if (SignInProvider.UserId == data['UserId']) {
                          haveData = 1;
                        }
                      }
                      dataCheck = true;
                    }
                    if (haveData == 0) {
                      setState(() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UploadId()));
                      });
                    }
                    if (haveData == 1) {
                      if(statusCheck==false){
                        var collection = FirebaseFirestore.instance.collection('UserUploadId');
                        var querySnapshot = await collection.get();
                        for (var queryDocumentSnapshot in querySnapshot.docs) {
                          Map<String, dynamic> data = queryDocumentSnapshot.data();
                          if (SignInProvider.UserId == data['UserId']) {
                            haveStatus = data['Status'];
                          }
                        }
                        statusCheck=true;
                      } else if(statusCheck==true){
                        if(timeCheck==false){
                          var collection = FirebaseFirestore.instance.collection('UserUploadId');
                          var querySnapshot = await collection.get();
                          for (var queryDocumentSnapshot in querySnapshot.docs) {
                            Map<String, dynamic> data = queryDocumentSnapshot.data();
                            if (SignInProvider.UserId == data['UserId']) {
                              haveExpTime = data["Exp-Date"];
                            }
                          }
                          timeCheck=true;
                        }
                        if (haveStatus == 0) {
                          DateTime now = DateTime.now();
                          print(uploadIdProvider.expTime);
                          String nExpTime =
                          Jiffy(haveExpTime).fromNow();

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(nExpTime),
                                  content: const Text(
                                      "Your Request will be processed in given time!"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: const Text("Go Back"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      }
                    }
                  },
                  child: Card(
                    child: ListTile(
                        title: FlatButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.track_changes),
                            label: const Text("Add ID")),
                        subtitle: Text(
                          '${0}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 40.0),
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 22, bottom: 22),
                child: Card(
                  child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.tag_faces),
                          label: const Text("Sold")),
                      subtitle: Text(
                        '0',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 12, top: 22, bottom: 22, left: 11),
                child: Card(
                  child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.shopping_cart),
                          label: Text("Orders")),
                      subtitle: Text(
                        '0',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 22, bottom: 22),
                child: Card(
                  child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.close),
                          label: Text("Return")),
                      subtitle: Text(
                        '0',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 60.0),
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  getAllUserDataEntry() async {}
}