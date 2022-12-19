import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Screen/HomePage/HomePage.dart';
import '../Screen/Login/LoginScreen.dart';
import '../Service/auth_service.dart';

class SignUpProvider with ChangeNotifier {
  bool isloading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController Username = TextEditingController();
  TextEditingController PhoneNo = TextEditingController();
  late double longitude;
  late double latitude;

  void SignUp(context, String Gender) async {
    bool isvalcheck = false;
    if (email.text.isEmpty) {
      Fluttertoast.showToast(msg: "Email is Empty");
    } else if (password.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is Empty");
    } else if (Username.text.isEmpty) {
      Fluttertoast.showToast(msg: "Username is Empty");
    } else if (PhoneNo.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone No is Empty");
    } else {
      isloading = true;
      notifyListeners();
      var collection = FirebaseFirestore.instance.collection('UserData');
      var querySnapshot = await collection.get();
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        if (email.text == data['email']) {
          isvalcheck = true;
          if (isvalcheck == true) {
            Fluttertoast.showToast(msg: "User Already Registered");
          }
        }
      }
      if (isvalcheck == false) {
        String id = FirebaseFirestore.instance.collection('UserData').doc().id;
        print(id);
        await FirebaseFirestore.instance.collection("UserData").doc(id).set({
          "UserId": id,
          "Username": Username.text,
          "email": email.text,
          "password": password.text,
          "PhoneNo": PhoneNo.text,
          "Gender": Gender,
          "is_admin": "0",
          "Status": "0",
          "longitude": longitude,
          "latitude": latitude,
        }).then((value) async {
          isloading = false;
          notifyListeners();
          email.clear();
          Username.clear();
          password.clear();
          PhoneNo.clear();
          await Fluttertoast.showToast(msg: "Successfully SignUp Data");
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage()));
        });
        Get.to(() => SignIn());
        notifyListeners();
      }
    }
  }

  Future<void> getCurrentPosition() async {
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
      this.latitude = position.latitude;
      this.longitude = position.longitude;
      //email
      print("latitude" +
          latitude.toString() +
          " longitude" +
          longitude.toString());
    }
  }
}
