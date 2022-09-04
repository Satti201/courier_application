
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:courier_application/Provider/SignInProvider.dart';
import 'package:courier_application/Provider/UploadIdProvider.dart';

import '../EditField/Colors.dart';
import '../Models/AllUserData.dart';
import '../Screen/HomePage/HomePage.dart';
import '../Screen/Parcel/AddParcel.dart';
import '../Screen/Parcel/Parcel.dart';
import '../Screen/UploadId/UploadId.dart';

class DrawerSide extends StatefulWidget {


  @override
  State<DrawerSide> createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  bool check = false;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  List<AllUserData> UserDataLists =[];
  Widget build(BuildContext context) {
    UploadIdProvider uploadIdProvider = Provider.of(context);
    Widget listTitle(IconData iconData , String title , Function ontap){
      return ListTile(
        onTap: (){
          ontap();
        },
        leading: Icon(
          iconData,
          size: 32,
        ),
        title: Text(title, style: const TextStyle(color: Colors.black45),),
      );
    }
    return SizedBox(
      width: 270,
      child: Drawer(
        child: Container(
          color: scaffoldbackgroundColor,
          child: ListView(
            children: [
              DrawerHeader(child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white54,
                    radius: 43,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage("https://i.pinimg.com/600x315/47/7f/a4/477fa4df6509e5120468638e7ab14d22.jpg") ,
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: Text("Usama Tariq", style: TextStyle(),),
                      ),
                      SizedBox(height: 7,),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: 25,
                          child: const Text("", style: TextStyle(),),
                        ),
                      )
                    ],
                  )
                ],
              )
              ),
              listTitle(Icons.home_outlined,"Home" ,(){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage()));
              }),
              listTitle(Icons.shop_outlined,"Add Parcel",() async {
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
               }),
              listTitle(Icons.person_outlined,"Show Parcel",(){
               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Parcel()));
              }),
              listTitle(Icons.notifications_outlined,"Upload Id",(){/*
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UploadId()));
*/

                uploadIdProvider.checkData(SignInProvider.UserId);
                if (uploadIdProvider.hasData == 0) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UploadId()));
                } else if (uploadIdProvider.hasData == 1) {
                  uploadIdProvider.getStatusOfId(SignInProvider.UserId);
                  if (uploadIdProvider.status == 0) {
                    uploadIdProvider.fetchExpTime(SignInProvider.UserId);
                    DateTime now = DateTime.now();
                    print(uploadIdProvider.expTime);
                    String nExpTime =Jiffy(uploadIdProvider.expTime).fromNow();

                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(nExpTime),
                            content: const Text(
                                "Your Request will be processed in given time!"),
                            actions: <Widget>[
                              FlatButton(
                                child: const Text("Go Back"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  }
                }

              }),
              listTitle(Icons.notifications_outlined,"My Bookings",(){

              }),
              listTitle(Icons.star_outlined,"Rating & Review",(){}),
              listTitle(Icons.copy_outlined,"Raise a Complaint",(){}),
              listTitle(Icons.format_quote_outlined,"FAQs",(){}),

              Container(
                height: 350,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Contact Support :"),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text("Call Us:"),
                        SizedBox(width: 10,),
                        Text("+92 03033354121"),

                      ],
                    ),
                    SizedBox(height: 5,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text("Mail Us:"),
                          SizedBox(width: 10,),
                          Text("tusama134@gmail.com"),

                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}

