import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courier_application/Provider/SignInProvider.dart';
import 'package:courier_application/Provider/UploadIdProvider.dart';
import 'package:courier_application/RoughWork/GoogleMap/UserGoogleMap.dart';
import 'package:courier_application/Screen/UploadId/UploadId.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jiffy/jiffy.dart';
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
  String time;

  SingleParcelItem(this.ParcelName, this.PickupAddress, this.RecieverAddress,
      this.orderid, this.ParcelPrice, this.time);

  @override
  State<SingleParcelItem> createState() => _SingleParcelItemState();
}

class _SingleParcelItemState extends State<SingleParcelItem> {
  var _storedImage;
  double? longitude;
  bool valcheck = false;
  bool timeCheck = false;
  double? latitude;
  File? imageFile;
  PickedFile? pickedFile;
  int Status = -0;
  String expTime='';
  bool val = false;
  DateTime date=DateTime.now();
  Widget build(BuildContext context) {
    SignUpProvider passportId = Provider.of(context);
    UploadIdProvider uploadIdProvider = Provider.of(context);
    uploadIdProvider.getStatusOfId(SignInProvider.UserId);
    uploadIdProvider.fetchExpTime(SignInProvider.UserId);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              direction: Axis.vertical,
              children: [
                Text(
                  widget.ParcelName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Order Id# ${widget.orderid}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Parcel Price|| ${widget.ParcelPrice}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Pickup Address|",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.PickupAddress,
                  maxLines: 3,
                  softWrap: false,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Receiver Address|",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.RecieverAddress,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
              color: Colors.black54,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //minimumSize: const Size(30, 40),
                  elevation: 5,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    //letterSpacing: 1,
                  ),
                ),
                onPressed: () async {
                  if (valcheck == false) {
                    await getCurrentPosition();
                    await uploadIdProvider.getStatusOfId(SignInProvider.UserId);
                    valcheck = true;
                  }
                  if (valcheck == true) {
                    if (uploadIdProvider.status == -1) {
                      return showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Add ID"),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FlatButton(
                                      child: const Text("Go To"),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const UploadId()));
                                      },
                                    ),
                                    FlatButton(
                                      child: const Text("NO"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        passportId.Username.text = "";
                                      },
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    } else if (uploadIdProvider.status == 0) {
                      print("status"+uploadIdProvider.status.toString());
                      if (timeCheck == false) {
                        await uploadIdProvider.fetchExpTime(SignInProvider.UserId);
                        timeCheck = true;
                      } else if (timeCheck == true) {
                       setState(() {
                         date = DateTime.parse(uploadIdProvider.expTime);
                       });
                        return showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(Jiffy(date).fromNow()),
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
                    } else if (uploadIdProvider.status == 1) {
                      if (latitude == null && longitude == null) {
                        Fluttertoast.showToast(msg: "Invalid Location");
                      } else {
                        final queryPickupAddress =
                            widget.PickupAddress.toString();
                        var addresses = await Geocoder.local
                            .findAddressesFromQuery(queryPickupAddress);
                        var PickUpfirst = addresses.first;

                        final queryDestinationAddress =
                            widget.RecieverAddress.toString();
                        var addresses1 = await Geocoder.local
                            .findAddressesFromQuery(queryDestinationAddress);
                        var RecieverAddressfirst = addresses1.first;

                        print(
                            "${PickUpfirst.featureName} : ${PickUpfirst.coordinates}");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserGoogleMap(
                                widget.time.toString(),
                                latitude.toString(),
                                longitude.toString(),
                                "Username",
                                PickUpfirst.coordinates.latitude,
                                PickUpfirst.coordinates.longitude,
                                RecieverAddressfirst.coordinates.latitude,
                                RecieverAddressfirst.coordinates.longitude)));
                      }
                    }
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Accept',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
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


  Future fetchExpTime(String userId) async {
    var collection = FirebaseFirestore.instance.collection('UserUploadId');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if (userId == data['UserId']) {
        expTime= data["ExpDate"];
      }
    }
  }

  Future getStatusOfId(String UserId) async {
    var collection = FirebaseFirestore.instance.collection('UserUploadId');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if (UserId == data['UserId']) {
        Status = data['Status'];
      }
    }
  }
}
