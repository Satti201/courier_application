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


  int Status=0;
  String message = "";



  void UserUploadId(context ,File Image , int Status) async {
    DateTime now = new DateTime.now();
    DateTime currDate = new DateTime(now.year, now.month, now.day);
    DateTime ExpDate = new DateTime(now.year, now.month, now.day);
    ExpDate =  ExpDate.add(Duration(days: 3));
    Response response = (await http.post(
        Uri.parse(
            'http://Biit_Obe_System_web_api/api/plo_Program/UpdatePlo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(""))) as Response;
    if(response.statusCode == 201 || response.statusCode == 200){
       message=jsonDecode(response.body);
    }
    if(message!=null){
      String id = FirebaseFirestore.instance.collection('UserUploadId').doc().id;
      await   FirebaseFirestore.instance.collection("UserUploadId").doc(id).set(
          {
            "UploadId" : id,
            "UserId" : SignInProvider.UserId,
            "Curr-Date" : currDate.toString(),
            "Exp-Date"  : ExpDate.toString(),
            "UserImageId" : message.toString(),
            "Status" : 0,
          }
      ).then((value) async {

        await Fluttertoast.showToast(msg: "Upload Id Successfully");
        Navigator.of(context).pop();

      });
    }
    



  }




  Future<int> getStatusOfId(String UserId) async {

    var collection = FirebaseFirestore.instance.collection('UserUploadId');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot
    in querySnapshot.docs) {
      Map<String, dynamic> data =
      queryDocumentSnapshot.data();
      if(UserId == data['UserId'] )
      {
      Status =  data['Status'];
      }

    }
  return Status;

  }






}