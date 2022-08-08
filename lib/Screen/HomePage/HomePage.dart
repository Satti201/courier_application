
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../EditField/Colors.dart';
import '../../Models/AllUserData.dart';
import '../../Provider/ParcelProvider.dart';
import '../../Widgets/DrawerSide.dart';
import '../Login/LoginScreen.dart';
import '../Parcel/AddParcel.dart';
import '../Parcel/Parcel.dart';





enum Page { dashboard, manage }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
   late ParcelProvider parcelProvider;
  late int Length;
  List<AllUserData> UserDataLists =[];
  bool check = false;




  @override
  Widget build(BuildContext context) {
     parcelProvider = Provider.of(context);
     parcelProvider.getParcelData();

    return WillPopScope(
      onWillPop: (){
         showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Logout"),
                content: Text("Are you sure you want to Logout?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () {
                     Get.to(()=> SignIn());
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
        return Future.value(true);


      },
      child: Scaffold(
        drawer: DrawerSide(),
          appBar: AppBar(
        backgroundColor: scaffoldbackgroundColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text("HomePage", style: TextStyle(color: Colors.black),),
      ),
          body: _loadScreen()),
    );
  }

  Widget _loadScreen() {


        return Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 12,top: 22,bottom: 22,left: 11),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Parcel()));
                        },
                        child: Card(
                          child: ListTile(
                              title: FlatButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.people_outline),
                                  label: Text("Parcels")),
                              subtitle: Text(
                                '${parcelProvider.getReviewCartData.length}',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 40.0),
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12,top: 22,bottom: 22),
                      child: GestureDetector(
                        onTap: () async {
                          if(check == false)
                            {
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
                              check = true;
                            }
                          if(check == true){
                           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddParcel(UserDataLists)));

                         }
                        },
                        child: Card(
                          child: ListTile(
                              title: FlatButton.icon(
                                  onPressed: null,
                                  icon: Icon(Icons.add),
                                  label: Text("Parcel")),
                              subtitle: Text(
                                '0',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: active, fontSize: 40.0),
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12,top: 22,bottom: 22,left: 11),
                      child: Card(
                        child: ListTile(
                            title: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.track_changes),
                                label: Text("Products")),
                            subtitle: Text(
                              '${0}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 40.0),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12,top: 22,bottom: 22),
                      child: Card(
                        child: ListTile(
                            title: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.tag_faces),
                                label: Text("Sold")),
                            subtitle: Text(
                              '0',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 60.0),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12,top: 22,bottom: 22,left: 11),
                      child: Card(
                        child: ListTile(
                            title: FlatButton.icon(
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
                      padding: const EdgeInsets.only(right: 12,top: 22,bottom: 22),
                      child: Card(
                        child: ListTile(
                            title: FlatButton.icon(
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
          ),
        );


  }
  getAllUserDataEntry() async{

  }


}