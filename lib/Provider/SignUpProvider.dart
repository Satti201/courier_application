
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Screen/Login/LoginScreen.dart';
import '../Service/auth_service.dart';


class SignUpProvider with ChangeNotifier{


  bool  isloading =false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController Username = TextEditingController();
  TextEditingController PhoneNo = TextEditingController();


  void SignUp(context , String Gender)async{
    bool isvalcheck = false;
    if(email.text.isEmpty){
      Fluttertoast.showToast(msg: "Email is Empty");
    }
    else if(password.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Password is Empty");
    }
    else if(Username.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Username is Empty");
    }
    else if(PhoneNo.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Phone No is Empty");
    }
    else {
      isloading = true;
      notifyListeners();
      var collection =
      FirebaseFirestore.instance.collection('UserData');
      var querySnapshot = await collection.get();
      for (var queryDocumentSnapshot
      in querySnapshot.docs) {
        Map<String, dynamic> data =
        queryDocumentSnapshot.data();
        if(email.text == data['email'] )
        {
          isvalcheck = true;
          if(isvalcheck == true)
          {
            Fluttertoast.showToast(msg: "User Already Registered");
          }
        }
      }
      if(isvalcheck == false)
      {
        String id = FirebaseFirestore.instance.collection('UserData').doc().id;
        print(id);
        await   FirebaseFirestore.instance.collection("UserData").doc(id).set(
            {
              "UserId" : id,
              "Username" : Username.text,
              "email" :  email.text,
              "password" : password.text,
              "PhoneNo" : PhoneNo.text,
              "Gender" : Gender,
            }
        ).then((value) async {
          isloading = false;
          notifyListeners();
          email.clear();
          Username.clear();
          password.clear();
          PhoneNo.clear();
          await Fluttertoast.showToast(msg: "Successfully SignUp Data");
          Navigator.of(context).pop();

        });
        Get.to(()=>SignIn());
        notifyListeners();
      }
    }

  }


}