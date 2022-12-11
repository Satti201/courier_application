
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../Provider/ParcelProvider.dart';
import '../../Provider/SignInProvider.dart';
import '../../Screen/HomePage/HomePage.dart';
import 'components/map_pin_pill.dart';
import 'models/pin_pill_info.dart';

class CurrentLocationScreen extends StatefulWidget {
  String latitude;
  String Longitude;
  String ParcelName;
  String ParcelAddress;
  int OrderId;



  CurrentLocationScreen(this.latitude, this.Longitude, this.ParcelName,
      this.ParcelAddress, this.OrderId);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {

  bool ischecked =false;
  String address = '' ;
  LatLng SOURCE_LOCATION = LatLng(24.8607, 67.0011);
  String googleAPIKey = '<AIzaSyBcmMJkHgwOR6DUwpsjM8KiOqLeZGtgunI>';
  LatLng ORIGON_LOCATION = LatLng(24.8607, 67.0011);
  late LatLng DESTINATION_LOCATION ;
  final Completer<GoogleMapController> _controller = Completer();
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  late PinInformation sourcePinInfo;
  late PinInformation destinationPinInfo;
   late PinInformation OriginPinInfo;
   double pinPillPosition = -100;
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  late BitmapDescriptor origonIcon;
  late String CurrentLocation_Lat;
  late String CurrentLocation_Long;






  Future<Position> _getUserCurrentLocation() async {


    await Geolocator.requestPermission().then((value) {

    }).onError((error, stackTrace){
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();

  }

  final List<Marker> _markers =  <Marker>[];

  static const CameraPosition _kGooglePlex =  CameraPosition(
    target: LatLng(24.8607, 67.0011),
    zoom: 16,
  );


  List<Marker> list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.6844, 73.0479),
        infoWindow: InfoWindow(
            title: 'some Info '
        )
    ),

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  _markers.addAll(list);

    loadData();
  }

  loadData(){
    _getUserCurrentLocation().then((value) async {

        CurrentLocation_Lat = value.latitude.toString();
        CurrentLocation_Long = value.longitude.toString();
      final GoogleMapController controller = await _controller.future;
      CameraPosition _kGooglePlex =  CameraPosition(
        target: LatLng(value.latitude ,value.longitude),
        zoom: 14,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    DESTINATION_LOCATION = LatLng(double.parse(widget.latitude), double.parse(widget.Longitude));
    ParcelProvider parcelProvider = Provider.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(_markers),
                onTap: (LatLng loc) {
                pinPillPosition = -100;
              },
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
              },
            ),
            MapPinPillComponent(
              pinPillPosition: pinPillPosition,
              currentlySelectedPin: currentlySelectedPin),
            Container(
              padding: EdgeInsets.only(right: 40),
              height: 80,
              // decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(120)
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 ischecked == false? InkWell(
                    onTap: () async{
                      _getUserCurrentLocation().then((value) async {
                        // CurrentLocation_Lat = value.latitude.toString() ;
                        // CurrentLocation_Long = value.longitude.toString();
                        _markers.add(
                            Marker(
                                markerId: const MarkerId('CurrentId'),
                                position: LatLng( value.latitude,value.longitude),
                                infoWindow:  InfoWindow(
                                    title: address
                                ),
                                icon: await BitmapDescriptor.fromAssetImage(
                                    ImageConfiguration(devicePixelRatio: 2.0), 'assets/driving_pin.png'),
                                onTap: (){
                                  setState(() {
                                    sourcePinInfo = PinInformation(
                                        locationName: "Start Location",
                                        location: SOURCE_LOCATION,
                                        pinPath: "assets/driving_pin.png",
                                        avatarPath: "assets/1.jpg",
                                        labelColor: Colors.blueAccent);
                                    currentlySelectedPin = sourcePinInfo;
                                    pinPillPosition = 0;
                                  });


                                }

                            )
                        );

                        _markers.add(
                            Marker(
                                markerId: const MarkerId('PickId'),
                                position: LatLng(25.3960, 68.3578),
                                icon: await BitmapDescriptor.fromAssetImage(
                                    ImageConfiguration(devicePixelRatio: 2.0), 'assets/destination_map_marker.png'),
                                infoWindow:  InfoWindow(
                                    title: address
                                ),
                                onTap :() {
                                  setState(() {
                                    OriginPinInfo = PinInformation(
                                        locationName: "PICK UP LOCATION",
                                        location: ORIGON_LOCATION,
                                        pinPath: "assets/driving_pin.png",
                                        avatarPath: "assets/1.jpg",
                                        labelColor: Colors.blueAccent);
                                    currentlySelectedPin = OriginPinInfo;
                                    pinPillPosition = 0;
                                  });
                                }

                            )
                        );

                        _markers.add(
                            Marker(
                              markerId: const MarkerId('DestId'),
                              position: DESTINATION_LOCATION,
                              infoWindow:  InfoWindow(
                                  title: address
                              ),
                              onTap :() {
                                setState(() {
                                  destinationPinInfo = PinInformation(
                                      locationName: "DROP OFF LOCATION",
                                      location: DESTINATION_LOCATION,
                                      pinPath: "assets/destination_map_marker.png",
                                      avatarPath: "assets/1.jpg",
                                      labelColor: Colors.blueAccent);
                                  currentlySelectedPin = destinationPinInfo;
                                  pinPillPosition = 0;
                                });
                              },
                              icon: await BitmapDescriptor.fromAssetImage(
                                  ImageConfiguration(devicePixelRatio: 2.0), 'assets/destination_map_marker.png'),
                            )
                        );
                        final GoogleMapController controller = await _controller.future;

                        CameraPosition _kGooglePlex =  CameraPosition(
                          target: LatLng(value.latitude ,value.longitude),
                          zoom: 16,
                        );
                        controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

                        List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude ,value.longitude);


                        final add = placemarks.first;
                        address = add.locality.toString() +" "+add.administrativeArea.toString()+" "+add.subAdministrativeArea.toString()+" "+add.country.toString();
                        ischecked = true;
                        setState(() {

                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 30),
                      child: Container(
                        height: 40,

                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Center(child: Text('Show Location' , style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ):
                 WillPopScope(
                   onWillPop: (){
                     showDialog(
                         context: context,
                         barrierDismissible: false,
                         builder: (BuildContext context) {
                           return AlertDialog(
                             title: Text("Confirm Cancel Parcel"),
                             content: Text("Are you sure you want to Cancel it?"),
                             actions: <Widget>[
                               TextButton(
                                 child: Text("YES"),
                                 onPressed: () {
                                   parcelProvider.deleteParcelData();
                                   parcelProvider.UpdateParcelStatus(context, widget.OrderId , 0);
                                   Get.to(()=> HomePage());
                                 },
                               ),
                               TextButton(
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
                   child: InkWell(
                     onTap: () {
                       showDialog(
                           context: context,
                           barrierDismissible: false,
                           builder: (BuildContext context) {
                             return AlertDialog(
                               title: Text("Start The Parcel Track"),
                               content: Text("Are you sure?"),
                               actions: <Widget>[
                                 TextButton(
                                   child: Text("YES"),
                                   onPressed: () {
                                     parcelProvider.confirmParcel(context, SignInProvider.UserId, widget.OrderId, widget.ParcelName, widget.ParcelAddress, widget.latitude, widget.Longitude, "Ongoing", "Time" , CurrentLocation_Lat , CurrentLocation_Long  );
                                     UpdateCurrentLatLong(double.parse(CurrentLocation_Lat),double.parse(CurrentLocation_Long));

                                   }
                                 ),
                                 TextButton(
                                   child: Text("NO"),
                                   onPressed: () {
                                     Navigator.of(context).pop();
                                   },
                                 )
                               ],
                             );
                           }
                       );


                     },
                     child: Padding(
                       padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 30),
                       child: Container(
                         height: 40,

                         decoration: BoxDecoration(
                             color: Colors.deepOrange,
                             borderRadius: BorderRadius.circular(30)
                         ),
                         child: Center(child: Text('Start' , style: TextStyle(color: Colors.white),)),
                       ),
                     ),
                   ),
                 ),
                ],
              ),
            )
          ],
        ),

      ),
    );
  }
  Future <void> UpdateCurrentLatLong( double Latitude ,double Longitude )
  async {
    FirebaseFirestore.instance.collection("ConfirmedParcel").doc(SignInProvider.UserId)
        .update(
        { 'CurrentLat': Latitude,
          'CurrentLong': Longitude,
        }
    );

  }

}
