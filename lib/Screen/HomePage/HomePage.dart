import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courier_application/Models/AllCategory.dart';

import 'package:courier_application/Provider/SignInProvider.dart';
import 'package:courier_application/Provider/UploadIdProvider.dart';
import 'package:courier_application/Screen/My_Parcel/my_parcel.dart';
import 'package:courier_application/Screen/Notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../EditField/Colors.dart';
import '../../Models/AllUserData.dart';
import '../../Models/ParcelData.dart';
import 'dart:math';
import '../../Provider/ParcelProvider.dart';
import '../../Widgets/DrawerSide.dart';
import '../Login/LoginScreen.dart';
import '../Parcel/AddParcel.dart';
import '../Parcel/Parcel.dart';
import '../UploadId/UploadId.dart';

enum Page { dashboard, manage }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  late ParcelProvider parcelProvider;
  late int Length;
  List<AllUserData> UserDataLists = [];
  double Distance = 0.0;

  List<double> Distance1 = [];
  List<AllCategory> catList = [];
  bool check = false;
  bool dataCheck = false;
  bool statusCheck = false;
  List<ParcelData> newList = [];
  bool timeCheck = false;
  int haveData = 0;
  late int haveStatus;
  late String haveExpTime;
  String newTime = 'Wait...';
  late int notStatus;
  final notificationCollection = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                  TextButton(
                    child: const Text("YES"),
                    onPressed: () {
                      Get.to(() => SignIn());
                    },
                  ),
                  TextButton(
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
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.notification_important,
                  color: Colors.purple,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          NotificationScreen(SignInProvider.UserId)));
                  // do something
                },
              )
            ],
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
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Parcel()));
                  },
                  child: Card(
                    child: ListTile(
                        title: TextButton.icon(
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

                      List<AllCategory> newCatList = [];
                      QuerySnapshot snapshot1 = await FirebaseFirestore.instance
                          .collection("ParcelCategory")
                          .get();
                      for (var element in snapshot1.docs) {
                        AllCategory categoryData = AllCategory(
                          element.get('categoryId'),
                          element.get('categoryName'),
                        );
                        newCatList.add(categoryData);
                      }
                      catList = newCatList;

                      check = true;
                    }
                    if (check == true) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AddParcel(UserDataLists, catList)));
                    }
                  },
                  child: Card(
                    child: ListTile(
                        title: TextButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.add),
                            label: const Text("Parcel")),
                        subtitle:
                            const Icon(Icons.inventory_2_outlined, size: 60)),
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
                          setState(() {
                            haveData = 1;
                          });
                        }
                      }
                      setState(() {
                        dataCheck = true;
                      });
                      print("have data: " + haveData.toString());
                    }
                    if (haveData == 0) {
                      setState(() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UploadId()));
                      });
                    } else if (haveData == 1) {
                      if (statusCheck == false) {
                        var collection = FirebaseFirestore.instance
                            .collection('UserUploadId');
                        var querySnapshot = await collection.get();
                        for (var queryDocumentSnapshot in querySnapshot.docs) {
                          Map<String, dynamic> data =
                              queryDocumentSnapshot.data();
                          if (SignInProvider.UserId == data['UserId']) {
                            setState(() {
                              haveStatus = data['Status'];
                            });
                          }
                        }
                        setState(() {
                          statusCheck = true;
                        });
                        print("have Status: " + haveStatus.toString());
                      }
                      if (haveStatus == 0) {
                        setState(() {
                          statusCheck = false;
                        });
                        if (timeCheck == false) {
                          var collection = FirebaseFirestore.instance
                              .collection('UserUploadId');
                          var querySnapshot = await collection.get();
                          for (var queryDocumentSnapshot
                              in querySnapshot.docs) {
                            Map<String, dynamic> data =
                                queryDocumentSnapshot.data();
                            if (SignInProvider.UserId == data['UserId']) {
                              setState(() {
                                haveExpTime = data["ExpDate"];
                              });
                            }
                          }
                          setState(() {
                            timeCheck = true;
                          });
                          print("check time${timeCheck}");
                        } else if (timeCheck == true) {
                          DateTime date = DateTime.parse(haveExpTime);
                          setState(() {
                            print("Exp time" + haveExpTime);
                            //newTime=Jiffy(date).fromNow();
                            timeCheck = false;
                          });
                          return showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(Jiffy(date).fromNow()),
                                  content: const Text(
                                      "Your Request will be processed in given time!"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("Go Back"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      } else if (haveStatus == 1) {
                        setState(() {
                          statusCheck = false;
                        });
                        return showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Accepted"),
                                content: const Text(
                                    "Your ID request was Accepted! Image wil be shown here!"),
                                actions: <Widget>[
                                  TextButton(
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
                  },
                  child: Card(
                    child: ListTile(
                        title: TextButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.track_changes),
                            label: const Text("Add ID")),
                        subtitle: const Icon(
                          Icons.image,
                          size: 60,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 22, bottom: 22),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MyParcel()));
                  },
                  child: Card(
                    child: ListTile(
                        title: TextButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.tag_faces),
                            label: const Text("My Parcel")),
                        subtitle: const Icon(
                          Icons.inventory_outlined,
                          size: 60,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 12, top: 22, bottom: 22, left: 11),
                child: Card(
                  child: ListTile(
                      title: TextButton.icon(
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
                      title: TextButton.icon(
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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
