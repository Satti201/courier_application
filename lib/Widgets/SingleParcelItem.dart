import 'dart:io';


import 'package:courier_application/Provider/SignInProvider.dart';
import 'package:courier_application/Provider/UploadIdProvider.dart';
import 'package:courier_application/RoughWork/GoogleMap/UserGoogleMap.dart';
import 'package:courier_application/Screen/UploadId/UploadId.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../Provider/SignUpProvider.dart';

import '../shared_components/async_button.dart';


class SingleParcelItem extends StatefulWidget {

  String ParcelName;

  String PickupAddress;
  String RecieverAddress;
  int orderid;
  String ParcelPrice;


  SingleParcelItem(this.ParcelName, this.PickupAddress, this.RecieverAddress,
      this.orderid, this.ParcelPrice);

  @override
  State<SingleParcelItem> createState() => _SingleParcelItemState();
}

class _SingleParcelItemState extends State<SingleParcelItem> {

  var _storedImage;
  late double longitude;
  late double latitude;
  File? imageFile ;
    PickedFile?  pickedFile;
    bool val = false;
  Widget build(BuildContext context) {
    SignUpProvider passportId = Provider.of(context);
    UploadIdProvider uploadIdProvider = Provider.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10 ,top: 10),
                child: Container(
                  height: 170,
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order Id :${widget.orderid}",
                            style:  TextStyle(color: Colors.black , fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text("Parcel Name :${widget.ParcelName}",
                            style:  TextStyle(color: Colors.black , ),),
                          SizedBox(height: 10,),
                          Text("PickUp Address :${widget.PickupAddress}",
                            maxLines: 3,
                            softWrap: false,
                            style:  TextStyle(color: Colors.black , fontSize: 14),),
                          SizedBox(height: 10,),
                          Text("RecieverAddress :${widget.RecieverAddress}",
                            overflow: TextOverflow.clip,
                            style:  TextStyle(color: Colors.black , fontSize: 14),),
                          SizedBox(height: 10,),
                          Text("Dollar Price: ${widget.ParcelPrice} \$",
                            style:  TextStyle(color: Colors.black , fontSize: 14),),

                          Padding(
                            padding: EdgeInsets.only(left: 230),
                            child: AsyncButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(30, 40),
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              onPressed: (){
                                uploadIdProvider.getStatusOfId(SignInProvider.UserId);
                                if(uploadIdProvider.Status == 0){
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Add ID"),
                                          actions: <Widget>[

                                            Row(
                                              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                              children: [
                                                FlatButton(
                                                  child: Text("Go To"),
                                                  onPressed: () {
                                                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UploadId()));
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text("NO"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    passportId.Username.text="";
                                                  },
                                                ),
                                              ],
                                            )



                                          ],
                                        );
                                      }
                                  );
                                }
                                else if(uploadIdProvider.Status == 1){
                                  getCurrentPosition();
                                  if(latitude == null && longitude == null){
                                    Fluttertoast.showToast(msg: "Invalid Location");
                                  }
                                  else {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserGoogleMap(latitude.toString(), longitude.toString(), "Username")));
                                  }

                                }





                              },
                              child: const Text("Accept"),
                            ),
                          ),

                        ],
                      ),




                    ],
                  ),
                ),
              ),



            ],
          ),
        ),
       Divider(
          height: 1,
          color: Colors.black54,
        )
      ],
    );
  }


  _getFromCamera() async {
  pickedFile = (await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    ))!;
    if (pickedFile != null) {
       imageFile = File(pickedFile!.path);
       val = true;
      print(imageFile!.path);
    }
  }
  Future getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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

