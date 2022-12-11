import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courier_application/Models/AllCategory.dart';
import 'package:courier_application/Screen/HomePage/HomePage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/ParcelData.dart';
import '../RoughWork/ConfirmParcel.dart';
import 'SignInProvider.dart';

class CategoryProvider with ChangeNotifier {
  bool isloading = false;
  TextEditingController categoryName = TextEditingController();

  void AddCategory(context, String cName) async {
    bool isvalcheck = false;
    if (categoryName.text.isEmpty) {
      Fluttertoast.showToast(msg: "Category is Empty");
    } else {
      isloading = true;
      notifyListeners();
      var collection = FirebaseFirestore.instance.collection('ParcelCategory');
      var querySnapshot = await collection.get();
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        if (categoryName.text == data['categoryName']) {
          isvalcheck = true;
          if (isvalcheck == true) {
            Fluttertoast.showToast(msg: "Category already Exists");
          }
        }
      }
      if (isvalcheck == false) {
        String id =
            FirebaseFirestore.instance.collection('ParcelCategory').doc().id;
        await FirebaseFirestore.instance
            .collection("ParcelCategory")
            .doc(id)
            .set({
          "categoryId": id,
          "categoryName": categoryName.text,
        }).then((value) async {
          isloading = false;
          notifyListeners();
          categoryName.clear();
          await Fluttertoast.showToast(msg: "Successfully created");
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage()));
        });
      }
    }
  }

  /*Future<void> UpdateParcelStatus(context, OrderId, int status) async {
    FirebaseFirestore.instance
        .collection("ParcelData")
        .doc(OrderId.toString())
        .update({
      'ParcelStatus': status,
    });
  }*/

  List<AllCategory> allCategoryList = [];

  void getCategory() async {
    List<AllCategory> newList = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("ParcelCategory").get();
    for (var element in snapshot.docs) {
      AllCategory categoryData = AllCategory(
        element.get('categoryId'),
        element.get('categoryName'),
      );
      newList.add(categoryData);
    }
    allCategoryList = newList;
  }

  List<AllCategory> get getReviewCartData {
    getCategory();
    return allCategoryList;
  }

  /*deleteParcelData() {
    FirebaseFirestore.instance
        .collection("ConfirmedParcel")
        .doc(SignInProvider.UserId)
        .delete();

    notifyListeners();
  }*/
}
