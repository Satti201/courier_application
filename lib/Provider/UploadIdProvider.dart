import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../Models/ParcelData.dart';
import '../RoughWork/ConfirmParcel.dart';
import 'SignInProvider.dart';
import 'package:http/http.dart' as http;

class UploadIdProvider with ChangeNotifier {
  int status =-1;
  int hasData =0;
  String message = "";
  String mess="i am satti";
  String expTime="";

  void UserUploadId(context, File Image, int Status) async {
    DateTime now = DateTime.now();
    DateTime currDate = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
    DateTime expDate = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
    expDate = expDate.add(const Duration(days: 3));

    var request = http.MultipartRequest('POST',
        Uri.parse('https://kjugmth.sendnow.app/api/ImageAPI/UploadFiles'));
    request.files.add(await http.MultipartFile.fromPath('', Image.path));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String messa = await response.stream.bytesToString();

      message=jsonDecode(messa);
      print("**************************************");
      print(message);
      if (message != null) {
        String id =
            FirebaseFirestore.instance.collection('UserUploadId').doc().id;
        await FirebaseFirestore.instance
            .collection("UserUploadId")
            .doc(id)
            .set({
          "UploadId": id,
          "UserId": SignInProvider.UserId,
          "CurrDate": currDate.toString(),
          "ExpDate": expDate.toString(),
          "UserImageId": message,
          "Status": 0,
        }).then((value) async {
          await Fluttertoast.showToast(msg: "Upload Id Successfully");
          Navigator.of(context).pop();
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<int> getStatusOfId(String UserId) async {
    var collection = FirebaseFirestore.instance.collection('UserUploadId');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if (UserId == data['UserId']) {
        status = data['Status'];
        print(status);
      }
    }
    return status;
  }

  Future<int> checkData(String userId) async {
    var collection = FirebaseFirestore.instance.collection('UserUploadId');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if (userId == data['UserId']) {
         hasData= 1;
         return hasData;
      }
    }
    return hasData;
  }


  Future<String> fetchExpTime(String userId) async {
    var collection = FirebaseFirestore.instance.collection('UserUploadId');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if (userId == data['UserId']) {
        expTime= data["ExpDate"];
        return expTime;
      }
    }
    return expTime;
  }
}
