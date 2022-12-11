import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courier_application/Screen/HomePage/HomePage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import '../Models/ParcelData.dart';
import '../RoughWork/ConfirmParcel.dart';
import 'SignInProvider.dart';

class ParcelProvider with ChangeNotifier {
  bool isloading = false;
  TextEditingController ParcelName = TextEditingController();
  TextEditingController ParcelCategory = TextEditingController();
  TextEditingController PickUpAddress = TextEditingController();
  TextEditingController ParcelOrderId = TextEditingController();
  TextEditingController ParcelPrice = TextEditingController();
  TextEditingController ReciverAddress = TextEditingController();
  TextEditingController Weight = TextEditingController();
  TextEditingController Dimensions = TextEditingController();
  void AddParcel(context, String CategoryName, String RecieverId, int Count) async {
    print("&&&&&&&&&&"+Weight.text);
    if (ParcelName.text.isEmpty) {
      Fluttertoast.showToast(msg: "ParcelName is Empty");
    } else if (PickUpAddress.text.isEmpty) {
      Fluttertoast.showToast(msg: "ParcelAddress is Empty");
    }else {
      await FirebaseFirestore.instance
          .collection("ParcelData")
          .doc(Count.toString())
          .set(
        {
          "PickUpId": SignInProvider.UserId,
          "ParcelName": ParcelName.text,
          "PickUpAddress": PickUpAddress.text,
          "OrderId": Count,
          "RecieverId": RecieverId,
          "ReceiverAddress": ReciverAddress.text,
          "Dimensions":Dimensions.text,
          "Weight": Weight.text,
          "ParcelPrice": ParcelPrice.text,
          "ParcelStatus": 0,
          "RiderId": "",
          "Category": CategoryName,

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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
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

  void getParcelData() async {
    //mylocation loc log
    //forloop(pickup loc)
    //
    List<ParcelData> newList = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("ParcelData").get();
    for (var element in snapshot.docs) {
      if(SignInProvider.UserId != element.get("PickUpId")){
        //string value=element.get(pickupaddress)
        /*GeoCode geoCode = GeoCode();
        GeoCode geoCode1 = GeoCode();
        try {
          Coordinates coordinates = await geoCode.forwardGeocoding(
              address:value;
          PickUplatitude = coordinates.latitude ;
          PickUpLongitude = coordinates.longitude ;

        } catch (e) {
          print(e);
        }*/
       // Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
        ParcelData  parcelData = ParcelData(
            element.get("ParcelName"),
            element.get('PickUpAddress'),
            element.get('ReceiverAddress'),
            element.get("OrderId"),
            element.get("ParcelPrice"),
            element.get("Weight"),
            element.get("Dimensions"),
          element.get("Category"),
        );
        newList.add(parcelData);
      }

    }
    ParcelDataList = newList;
    print(ParcelDataList.length);
  }

  List<ParcelData> get getReviewCartData {
    getParcelData();
    return ParcelDataList;
  }

  deleteParcelData() {
    FirebaseFirestore.instance
        .collection("ConfirmedParcel")
        .doc(SignInProvider.UserId)
        .delete();

    notifyListeners();
  }
}
