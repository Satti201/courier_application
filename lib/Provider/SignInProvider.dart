
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../Models/AllUserData.dart';
import '../Screen/HomePage/HomePage.dart';
import '../Screen/Splash.dart';


class SignInProvider with ChangeNotifier{

  bool  isloading =false;
  double longitude=0.0;
  double latitude=0.5;
  static String UserId = '';
  static String Username = '';
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future <void> UpdateSignUpData( double Latitude ,double Longitude )
  async {
    FirebaseFirestore.instance.collection("UserData").doc(UserId)
        .update(
        { 'longitude': Latitude,
          'latitude': Longitude,
        }
    );

  }



    void getUserData(context) async{
      bool isvalcheck = false ;
      var collection =
      FirebaseFirestore.instance.collection('UserData');
      var querySnapshot = await collection.get();
      for (var queryDocumentSnapshot
      in querySnapshot.docs) {
        Map<String, dynamic> data =
        queryDocumentSnapshot.data();
        if(email.text == data['email'] && password.text == data['password'])
          {
            isvalcheck = true;
            SplashScreen.loggendIn = true;
            UserId = queryDocumentSnapshot.id;
            Username = data['Username'];
            isloading = true;
         //   getCurrentPosition(context);
            Fluttertoast.showToast(msg: " User Login Successfully");
            email.clear();
            password.clear();
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage()));
          }

      }
      if(isvalcheck==false) {
        Fluttertoast.showToast(msg: " Login Failed");
      }




    }

  List<AllUserData> UserDataLists =[];
  List<String> UserIdList =[];

  Future<List<AllUserData>> getAllUserDataEntry() async{
    List<AllUserData> newList =[];
    QuerySnapshot snapshot =  await FirebaseFirestore.instance.collection("UserData").get();
    snapshot.docs.forEach((element) {
      AllUserData parcelData = AllUserData(
        element.get("UserId"),
        element.get("Username"),
        element.get("email"),
        element.get('password'),
        element.get("PhoneNo"),

      );

      newList.add(parcelData);
    });
    UserDataLists= newList;
    return UserDataLists;

  }

  List<AllUserData>  get getuserlists {
    return UserDataLists;
  }



  Future<void> getCurrentPosition(context) async {
    LocationPermission permission;
    bool serviceEnabled;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      print(placemarks);
      latitude = position.latitude;
      longitude = position.longitude;
      UpdateSignUpData(latitude, longitude);
      notifyListeners();
    }
  }




  void SignIn(context){
    if(email.text.isEmpty){
      Fluttertoast.showToast(msg: "Email is Empty");
    }
    else if(password.text.isEmpty)
      {
        Fluttertoast.showToast(msg: "Password is Empty");
      }

    else {
      getUserData(context);
    }

  }
}