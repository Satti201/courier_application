import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courier_application/Screen/HomePage/HomePage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/ParcelData.dart';
import '../RoughWork/ConfirmParcel.dart';
import 'SignInProvider.dart';


class ParcelProvider with ChangeNotifier {


  bool isloading = false;

  TextEditingController ParcelName = TextEditingController();
  TextEditingController PickUpAddress = TextEditingController();
  TextEditingController ParcelOrderId = TextEditingController();
  TextEditingController ParcelPrice = TextEditingController();
  TextEditingController ReciverAddress = TextEditingController();
  TextEditingController Time = TextEditingController();



  void AddParcel(context ,String RecieverId , int Count) async {
    if (ParcelName.text.isEmpty) {
      Fluttertoast.showToast(msg: "ParcelName is Empty");
    }
    else if (PickUpAddress.text.isEmpty) {
      Fluttertoast.showToast(msg: "ParcelAddress is Empty");
    }

    else {
      await FirebaseFirestore.instance.collection("ParcelData").doc(
          Count.toString()).set(
        {
          "PickUpId": SignInProvider.UserId,
          "ParcelName": ParcelName.text,
          "PickUpAddress": PickUpAddress.text,
          "OrderId": Count,
          "RecieverId": RecieverId,
          "ReceiverAddress": ReciverAddress.text,
          "ParcelPrice": ParcelPrice.text,
          "Time": Time.text,
          "ParcelStatus": 0,
          "RiderId": ""
        },
      ).then((value) async {
        isloading = false;
        notifyListeners();
        await Fluttertoast.showToast(msg: "Successfully Add Parcel Data");
        ReciverAddress.clear();
        ParcelPrice.clear();
        Time.clear();
        ParcelName.clear();
        PickUpAddress.clear();
        ParcelOrderId.clear();
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomePage()));
      });
    }
  }


  Future <void> UpdateParcelStatus(context, OrderId , int status) async {
    FirebaseFirestore.instance.collection("ParcelData").doc(OrderId.toString())
        .update(
        {
          'ParcelStatus': status,
        }
    );
  }


  void confirmParcel(context, String Userid, int OrderId, String ParcelName,
      String Address
      , String ParcelLat, String ParcelLongitude, String Status, String Time,
      String CurrentLocation_Lat
      , String CurrentLocation_Long) async {
    FirebaseFirestore.instance.collection("ConfirmedParcel").doc(SignInProvider.UserId).set(
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
      UpdateParcelStatus(context, OrderId , 1);
      await Fluttertoast.showToast(msg: "Confirmed Parcel Data");
      Navigator.of(context).pop();
    });
  }


  List<ConfirmParcelData> ConfirmParcelDataList = [];

  Future<void> getallconfirmedParcelDetails() async {
    List<ConfirmParcelData> newList = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
        "ConfirmedParcel").get();
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
    List<ParcelData> newList = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
        "ParcelData").get();
    snapshot.docs.forEach((element) {
      ParcelData parcelData = ParcelData(
        element.get("ParcelName"),
        element.get('PickUpAddress'),
        element.get('ReceiverAddress'),
        element.get("OrderId"),
        element.get("ParcelPrice"),

      );
   newList.add(parcelData);
    });
    ParcelDataList = newList;
    print(ParcelDataList.length);
  }

  List<ParcelData> get getReviewCartData {
    return ParcelDataList;
  }



  deleteParcelData(){
    FirebaseFirestore.instance.collection("ConfirmedParcel")
        .doc(SignInProvider.UserId)
        .delete();

    notifyListeners();

  }




}