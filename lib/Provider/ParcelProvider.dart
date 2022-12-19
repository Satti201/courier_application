import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courier_application/Screen/HomePage/HomePage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';
import '../Models/ParcelData.dart';
import '../RoughWork/ConfirmParcel.dart';
import 'SignInProvider.dart';

class ParcelProvider with ChangeNotifier {
  bool isloading = false;
  String disInMiles = "1";
  String myParcelStatus="0";
  TextEditingController ParcelName = TextEditingController();
  TextEditingController ParcelCategory = TextEditingController();
  TextEditingController PickUpAddress = TextEditingController();
  TextEditingController ParcelOrderId = TextEditingController();
  TextEditingController ParcelPrice = TextEditingController();
  TextEditingController ReciverAddress = TextEditingController();
  TextEditingController Weight = TextEditingController();
  TextEditingController ParcelInsurance = TextEditingController();
  TextEditingController Dimensions = TextEditingController();
  void AddParcel(
      context, String CategoryName, String RecieverId, int Count) async {
    if (ParcelName.text.isEmpty) {
      Fluttertoast.showToast(msg: "ParcelName is Empty");
    } else if (PickUpAddress.text.isEmpty) {
      Fluttertoast.showToast(msg: "ParcelAddress is Empty");
    } else {
      String id = FirebaseFirestore.instance.collection('ParcelData').doc().id;
      await FirebaseFirestore.instance.collection("ParcelData").doc(id).set(
        {
          "PickUpId": SignInProvider.UserId,
          "Username": SignInProvider.Username,
          "ParcelName": ParcelName.text,
          "PickUpAddress": PickUpAddress.text,
          "OrderId": Count,
          "RecieverId": RecieverId,
          "ReceiverAddress": ReciverAddress.text,
          "Dimensions": Dimensions.text,
          "Weight": Weight.text,
          "ParcelPrice": ParcelPrice.text,
          "ParcelStatus": 0,
          "RiderId": "",
          "Category": CategoryName,
          "ParcelInsurance": ParcelInsurance.text,
        },
      ).then((value) async {
        isloading = false;
        notifyListeners();
        await Fluttertoast.showToast(msg: "Successfully Add Parcel Data");
        ReciverAddress.clear();
        ParcelPrice.clear();
        Weight.clear();
        Dimensions.clear();
        ParcelName.clear();
        PickUpAddress.clear();
        ParcelOrderId.clear();
        ParcelCategory.clear();
        ParcelInsurance.clear();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));
      });
    }
  }

  Future<void> UpdateParcelStatus(context, OrderId, int status) async {
    FirebaseFirestore.instance
        .collection("ParcelData")
        .doc(OrderId.toString())
        .update({
      'ParcelStatus': status,
    });
  }

  void confirmParcel(
      context,
      String Userid,
      int OrderId,
      String ParcelName,
      String Address,
      String ParcelLat,
      String ParcelLongitude,
      String Status,
      String Time,
      String CurrentLocation_Lat,
      String CurrentLocation_Long) async {
    FirebaseFirestore.instance
        .collection("ConfirmedParcel")
        .doc(SignInProvider.UserId)
        .set(
      {
        "UserId": Userid,
        "ParcelStatus": Status,
        "Time": Time,
        "ParcelName": ParcelName,
        "ParcelAddress": Address,
        "OrderId": OrderId,
        "latitude": ParcelLat,
        "longitude": ParcelLongitude,
        "CurrentLocationLat": CurrentLocation_Lat,
        "CurrentLocationLong": CurrentLocation_Long,
      },
    ).then((value) async {
      isloading = false;
      notifyListeners();
      UpdateParcelStatus(context, OrderId, 1);
      await Fluttertoast.showToast(msg: "Confirmed Parcel Data");
      Navigator.of(context).pop();
    });
  }

  List<ConfirmParcelData> ConfirmParcelDataList = [];

  Future<void> getallconfirmedParcelDetails() async {
    List<ConfirmParcelData> newList = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("ConfirmedParcel").get();
    snapshot.docs.forEach((element) {
      ConfirmParcelData CparcelData = ConfirmParcelData(
        element.get("ParcelName"),
        element.get("OrderId"),
        element.get('ParcelAddress'),
        element.get("latitude"),
        element.get("longitude"),
        element.get("ParcelStatus"),
        element.get("Time"),
        element.get("UserId"),
        element.get("CurrentLocationLong"),
        element.get("CurrentLocationLat"),
      );
      newList.add(CparcelData);
    });
    ConfirmParcelDataList = newList;
  }

  List<ConfirmParcelData> get getConfirmedParcelData {
    return ConfirmParcelDataList;
  }

  List<ParcelData> ParcelDataList = [];

  List<double> Distance1 = [];

  void getParcelData() async {
    List<ParcelData> newList = [];
    double? PickUplatitude, PickUpLongitude;
    bool val = false;

    /*if ((await Geolocator.isLocationServiceEnabled())) {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        _currentPosition = position;
        SignInProvider.latitude = _currentPosition.latitude;
        SignInProvider.longitude = _currentPosition.longitude;
      });}*/
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("ParcelData").get();
    for (var element in snapshot.docs) {
      if (SignInProvider.UserId != element.get("PickUpId")) {
        val=true;
        try {
          double Distance = 0.0;
          String value = element.get("PickUpAddress");

          List<Location> locations = await locationFromAddress(value);

          Location location;
          location = locations[0];

          PickUplatitude = location.latitude;
          PickUpLongitude = location.longitude;

          Distance += calculateDistance(SignInProvider.latitude,
              SignInProvider.longitude, PickUplatitude, PickUpLongitude);

          if (Distance <= double.parse(disInMiles)) {
            ParcelData parcelData = ParcelData(
              element.get("ParcelName"),
              element.get("PickUpAddress"),
              element.get("ReceiverAddress"),
              element.get("OrderId"),
              element.get("ParcelPrice"),
              element.get("Weight"),
              element.get("Dimensions"),
              element.get("Category"),
              element.get("ParcelInsurance"),
              element.get("Username"),
            );
            newList.add(parcelData);
          }
        } catch (e) {
          print(e);
        }
      } else {
        val == false;
        print("Parcel not found");
      }
    }
    ParcelDataList = newList;
  }

  List<ParcelData> get getReviewCartData {
    getParcelData();
    return ParcelDataList;
  }

  //my parcels
  List<ParcelData> ParcelMyParcelDataList = [];

  void getMyParcelData() async {
    List<ParcelData> newList = [];
    bool val = false;

    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection("ParcelData").get();
    for (var element in snapshot.docs) {
      if (SignInProvider.UserId == element.get("PickUpId") && myParcelStatus==element.get("ParcelStatus")) {
        try {
          val=true;
            ParcelData parcelData = ParcelData(
              element.get("ParcelName"),
              element.get("PickUpAddress"),
              element.get("ReceiverAddress"),
              element.get("OrderId"),
              element.get("ParcelPrice"),
              element.get("Weight"),
              element.get("Dimensions"),
              element.get("Category"),
              element.get("ParcelInsurance"),
              element.get("Username"),
            );
            newList.add(parcelData);
        } catch (e) {
          print(e);
        }
      } else {
        val == false;
        print("Parcel not found");
      }
    }
    ParcelMyParcelDataList = newList;
  }


  List<ParcelData> get getReviewMyParcelData {
    getMyParcelData();
    print("My Parcel List Length"+ParcelMyParcelDataList.length.toString());
    return ParcelMyParcelDataList;
  }


  deleteParcelData() {
    FirebaseFirestore.instance
        .collection("ConfirmedParcel")
        .doc(SignInProvider.UserId)
        .delete();

    notifyListeners();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    /*var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));*/
    return sqrt((lat2 - lat1) * (lat2 - lat1) + (lon2 - lon1) * (lon2 - lon1));
  }
}
